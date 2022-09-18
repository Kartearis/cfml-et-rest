
<cfcomponent hint="Error specific functions" displayname="errors">

  <cfobject name="objUsers" component="users">

  <cffunction name="buildError" access="private" output="false" returntype="struct">
    <cfargument name="query" required="true" type="query" />

    <cfreturn {
      "id": #query.id#,
      "shortDescription": #query.short_description#,
      "description": #query.description#,
      "created_at": #query.created_at#,
      "created_by": {
        "id": #query.userId#,
        "name": #query.name#,
        "surname": #query.surname#
      },
      "state": {
        "id": #query.state_id#,
        "name": #query.state_name#
      },
      "level": {
        "id": #query.level_id#,
        "name": #query.level_name#
      },
      "urgency": {
        "id": #query.urgency_id#,
        "name": #query.urgency_name#
      }
  }>
  </cffunction>

  <!--- Error Details --->
  <cffunction name="getError" access="public" output="false" hint="Get error details" returntype="struct">
    <cfargument name="id" required="true" type="numeric" />

    <cfset var resObj = {}>
    <cfquery name="errors" datasource="db">
      SELECT
        defects.id,
        defects.short_description,
        defects.description,
        DATE_FORMAT(CONVERT_TZ(defects.created_at, @@session.time_zone, '+00:00'), '%Y-%m-%dT%TZ') as created_at,
        users.id as userId,
        users.name,
        users.surname,
        dict_defect_state.id as state_id,
        dict_defect_state.name as state_name,
        dict_defect_level.id as level_id,
        dict_defect_level.name as level_name,
        dict_defect_urgency.id as urgency_id,
        dict_defect_urgency.name as urgency_name
      FROM defects
        INNER JOIN users ON users.id = defects.created_by
        INNER JOIN dict_defect_state ON dict_defect_state.id = defects.state_id
        INNER JOIN dict_defect_level ON dict_defect_level.id = defects.level_id
        INNER JOIN dict_defect_urgency ON dict_defect_urgency.id = defects.urgency_id
      WHERE defects.id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif not errors.recordCount> <!--- if error not found --->
      <cfset resObj["status"] = false>
      <cfset resObj["message"] = "Incorrect error id provided.">
    <cfelse> <!--- if user found --->
      <cfset resObj["status"] = true>
      <cfset resObj["data"] = SerializeJSON(buildError(errors))>
    </cfif>

    <cfreturn resObj>
  </cffunction>

  <cffunction name="getErrors" access="public" output="false" hint="Get all errors" returntype="string">
    <cfset returnArray = ArrayNew(1) />
    <cfquery name="errors" datasource="db">
      SELECT
        defects.id,
        defects.short_description,
        defects.description,
        DATE_FORMAT(CONVERT_TZ(defects.created_at, @@session.time_zone, '+00:00'), '%Y-%m-%dT%TZ') as created_at,
        users.id as userId,
        users.name,
        users.surname,
        dict_defect_state.id as state_id,
        dict_defect_state.name as state_name,
        dict_defect_level.id as level_id,
        dict_defect_level.name as level_name,
        dict_defect_urgency.id as urgency_id,
        dict_defect_urgency.name as urgency_name
      FROM defects
        INNER JOIN users ON users.id = defects.created_by
        INNER JOIN dict_defect_state ON dict_defect_state.id = defects.state_id
        INNER JOIN dict_defect_level ON dict_defect_level.id = defects.level_id
        INNER JOIN dict_defect_urgency ON dict_defect_urgency.id = defects.urgency_id
    </cfquery>
    <cfloop query="errors">
      <cfset ArrayAppend(returnArray, buildError(errors)) />
    </cfloop>

    <cfreturn SerializeJSON(returnArray)>
  </cffunction>

  <cffunction name="createError" access="public" output="false" hint="Create error" returntype="struct">
    <cfargument name="shortDescription" required="true" type="string" />
    <cfargument name="description" required="true" type="string" />
    <cfargument name="level_id" required="true" type="numeric" />
    <cfargument name="urgency_id" required="true" type="numeric" />

    <cfset var resObj = {}>

    <cfset token = GetHttpRequestData().Headers.authorization>
    <cfset userId = objUsers.getCurrentUserId(token)>
    <cfset stateNew = 1>
    <cftry>
      <cfquery datasource="db" name="createError" result="result">
        INSERT INTO defects (
          short_description,
          description,
          created_by,
          state_id,
          level_id,
          urgency_id
        )
        VALUES (
          <cfqueryparam value="#shortDescription#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#description#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">,
          <cfqueryparam value="#stateNew#" cfsqltype="cf_sql_integer">,
          <cfqueryparam value="#level_id#" cfsqltype="cf_sql_integer">,
          <cfqueryparam value="#urgency_id#" cfsqltype="cf_sql_integer">
        )
      </cfquery>
      <cfcatch type="database">
        <cfset resObj["status"] = false>
        <cfset resObj["message"] = "Could not add error. Maybe some id error?">
        <cfreturn resObj>
      </cfcatch>
    </cftry>
    <cfset resObj["status"] = true>
    <cfset resObj["errorId"] = SerializeJSON(result.GENERATEDKEY)>
    <cfreturn resObj>
  </cffunction>

  <cffunction name="updateError" access="public" output="false" hint="Update error" returntype="boolean">
    <cfargument name="errorId" required="true" type="numeric" />
    <cfargument name="shortDescription" required="true" type="string" />
    <cfargument name="description" required="true" type="string" />
    <cfargument name="state" required="true" type="string" />
    <cfargument name="level" required="true" type="string" />
    <cfargument name="urgency" required="true" type="string" />
    <cfset returnArray = ArrayNew(1) />
    <cfset var resObj = {}>
    <cfset resObj["data"] = SerializeJSON(returnArray)>
    <cfreturn true>
  </cffunction>

</cfcomponent>
