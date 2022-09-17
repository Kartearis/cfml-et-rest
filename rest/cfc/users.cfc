
<cfcomponent hint="User specific functions" displayname="users">


  <!--- User Details --->
  <cffunction name="getUser" access="public" output="false" hint="Get user details" returntype="struct">

    <cfargument name="userid" required="true" type="numeric" />
    <cfset var resObj = {}>
    <cfset returnArray = ArrayNew(1) />

    <!--- <cfquery> to get user details --->
    <cfset token = GetHttpRequestData().Headers.authorization>
    <cfset jwt = new jwt(Application.jwtkey)>
    <cfset userId = jwt.decode(token).userId>

    <cfif 1 neq 1> <!--- if user not found --->
      <cfset resObj["success"] = false>
      <cfset resObj["message"] = "Incorrect user id provided.">
    <cfelse> <!--- if user found --->
      <cfset userStruct = StructNew() />
      <cfset userStruct["firstname"] = "John" />
      <cfset userStruct["lastname"] = "Doe" />
      <cfset userStruct["email"] = "johndoe@fakemail.com" />
      <cfset userStruct["id"] = userId />
      <cfset ArrayAppend(returnArray,userStruct) />

      <cfset resObj["success"] = true>
      <cfset resObj["data"] = SerializeJSON(returnArray)>

    </cfif>

    <cfreturn resObj>
  </cffunction>

  <cffunction name="getUsers" access="public" output="false" hint="Get all users" returntype="struct">
    <cfset returnArray = ArrayNew(1) />
    <cfset var resObj = {}>
    <cfset resObj["data"] = SerializeJSON(returnArray)>
    <cfreturn resObj>
  </cffunction>

  <cffunction name="createUser" access="public" output="false" hint="Create user" returntype="boolean">
    <cfargument name="name" required="true" type="string" />
    <cfargument name="surname" required="true" type="string" />
    <cfargument name="login" required="true" type="string" />
    <cfargument name="password" required="true" type="string" />
    <cfset returnArray = ArrayNew(1) />
    <cfset var resObj = {}>
    <cfset resObj["data"] = SerializeJSON(returnArray)>
    <cfreturn true>
  </cffunction>

  <cffunction name="updateUser" access="public" output="false" hint="Update user" returntype="boolean">
    <cfargument name="userId" required="true" type="numeric" />
    <cfargument name="name" required="true" type="string" />
    <cfargument name="surname" required="true" type="string" />

    <cfreturn true>
  </cffunction>

</cfcomponent>
