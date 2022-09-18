
<cfcomponent hint="History specific functions" displayname="Error history">

  <cfobject name="objUsers" component="users">

  <cffunction name="getErrorHistory" access="public" output="false" hint="Get history for error" returntype="struct">
    <cfargument name="errorId" required="true" type="numeric" />

    <cfset var resObj = {}>
    <cfset returnArray = ArrayNew(1) />

    <cfquery datasource="db" name="history">
      SELECT
        defect_history.id,
        DATE_FORMAT(CONVERT_TZ(date, @@session.time_zone, '+00:00'), '%Y-%m-%dT%TZ') as date,
        users.id as userId,
        users.name,
        users.surname,
        dict_history_action.id as action_id,
        dict_history_action.name as action_name,
        comment
      FROM defect_history
        INNER JOIN users ON users.id = defect_history.user_id
        INNER JOIN dict_history_action ON defect_history.action_id = dict_history_action.id
      WHERE defect_history.defect_id = <cfqueryparam value="#errorId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfloop query="history">
      <cfset ArrayAppend(returnArray, {
        "id": #id#,
        "date": #date#,
        "comment": #comment#,
        "user": {
          "id": #userId#,
          "name": #name#,
          "surname": #surname#
        },
        "action": {
          "id": #action_id#,
          "name": #action_name#
        }
      }) />
    </cfloop>

    <cfset resObj["success"] = true>
    <cfset resObj["data"] = SerializeJSON(returnArray)>

    <cfreturn resObj>
  </cffunction>

  <cffunction name="appendErrorHistory" access="public" output="false" hint="Add entry to error history" returntype="struct">
    <cfargument name="errorId" required="true" type="numeric" />
    <cfargument name="action_id" required="true" type="numeric" />
    <cfargument name="comment" required="true" type="string" />

    <cfset token = GetHttpRequestData().Headers.authorization>
    <cfset userId = objUsers.getCurrentUserId(token)>

    <cfquery datasource="db" name="history" result="result">
      INSERT INTO defect_history (user_id, action_id, comment, defect_id)
      VALUES (
        <cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#action_id#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#comment#" cfsqltype="cf_sql_longvarchar">,
        <cfqueryparam value="#errorId#" cfsqltype="cf_sql_integer">
      )
    </cfquery>
    <cfset var resObj = {}>

    <cfset resObj["status"] = true>
    <cfset resObj["historyId"] = SerializeJSON(result.GENERATEDKEY)>

    <cfreturn resObj>
  </cffunction>


</cfcomponent>
