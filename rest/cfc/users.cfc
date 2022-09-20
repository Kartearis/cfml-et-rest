
<cfcomponent hint="User specific functions" displayname="users">

  <cffunction name="getCurrentUserId" access="public" output="false" returntype="numeric">
    <cfargument name="token" required="true" type="string">

    <cfset jwt = new jwt(Application.jwtkey)>
    <cfset userId = jwt.decode(token).userId>
    <cfreturn userId>
  </cffunction>

  <!--- User Details --->
  <cffunction name="getUser" access="public" output="false" hint="Get user details" returntype="struct">
    <cfargument name="id" required="true" type="numeric" />

    <cfset var resObj = {}>
    <cfset returnArray = ArrayNew(1) />

    <cfquery name="usersById" datasource="db">
      SELECT name, surname, login FROM users
      WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
      LIMIT 1
    </cfquery>

    <cfif not usersById.recordCount> <!--- if user not found --->
      <cfset resObj["status"] = false>
      <cfset resObj["message"] = "Incorrect user id provided.">
    <cfelse> <!--- if user found --->
      <cfset resObj["status"] = true>
      <cfset resObj["data"] = SerializeJSON({"name": #usersById.name#, "surname": #usersById.surname#, "login": #usersById.login#})>
    </cfif>

    <cfreturn resObj>
  </cffunction>

  <cffunction name="getUsers" access="public" output="false" hint="Get all users" returntype="string">

    <cfset returnArray = ArrayNew(1) />
    <cfquery name="users" datasource="db">
      SELECT id, name, surname, login FROM users
    </cfquery>
    <cfloop query="users">
      <cfset ArrayAppend(returnArray, {"id": #id#, "name": #name#, "surname": #surname#, "login": #login#}) />
""    </cfloop>

    <cfreturn SerializeJSON(returnArray)>
  </cffunction>

  <cffunction name="createUser" access="public" output="false" hint="Create user" returntype="struct">
    <cfargument name="name" required="true" type="string" />
    <cfargument name="surname" required="true" type="string" />
    <cfargument name="login" required="true" type="string" />
    <cfargument name="password" required="true" type="string" />

    <cfset hash = Hash(password, "SHA-256") />
    <cfset var resObj = {}>

    <cftry>
      <cfquery datasource="db" result="result">
        INSERT INTO users (
            name, surname, login, password_hash
        ) VALUES (
          <cfqueryparam value="#name#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#surname#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#login#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#hash#" cfsqltype="cf_sql_varchar">
        )
      </cfquery>
      <cfcatch type="database">
        <cfset resObj["status"] = false>
        <cfreturn resObj>
      </cfcatch>
    </cftry>

    <cfset resObj["status"] = true>
    <cfset resObj["userId"] = SerializeJSON(result.GENERATEDKEY)>
    <cfreturn resObj>
  </cffunction>

  <cffunction name="updateUser" access="public" output="false" hint="Update user" returntype="struct">
    <cfargument name="id" required="true" type="numeric" />
    <cfargument name="name" required="true" type="string" />
    <cfargument name="surname" required="true" type="string" />

    <cfset var resObj = {}>

    <cftry>
      <cfquery name="updateUser" datasource="db" result="result">
        UPDATE users
        SET name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
          surname = <cfqueryparam value="#arguments.surname#" cfsqltype="cf_sql_varchar">
        WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfcatch type="database">
        <cfset resObj["status"] = false>
        <cfreturn resObj>
      </cfcatch>
    </cftry>

    <cfset resObj["status"] = true>
    <cfset resObj["userId"] = SerializeJSON(id)>
    <cfreturn resObj>
  </cffunction>

</cfcomponent>
