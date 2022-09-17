
<cfcomponent hint="Error specific functions" displayname="errors">


  <!--- Error Details --->
  <cffunction name="getError" access="public" output="false" hint="Get error details" returntype="struct">

    <cfargument name="errorId" required="true" type="numeric" />
    <cfset var resObj = {}>
    <cfset returnArray = ArrayNew(1) />

    <!--- <cfquery> to get user details --->

    <cfif 1 neq 1> <!--- if user not found --->
      <cfset resObj["success"] = false>
      <cfset resObj["message"] = "Incorrect user id provided.">
    <cfelse> <!--- if user found --->
      <cfset userStruct = StructNew() />
      <cfset userStruct["firstname"] = "John" />
      <cfset userStruct["lastname"] = "Doe" />
      <cfset userStruct["email"] = "johndoe@fakemail.com" />
      <cfset ArrayAppend(returnArray,userStruct) />

      <cfset resObj["success"] = true>
      <cfset resObj["data"] = SerializeJSON(returnArray)>

    </cfif>

    <cfreturn resObj>
  </cffunction>

  <cffunction name="getErrors" access="public" output="false" hint="Get all errors" returntype="struct">
    <cfset returnArray = ArrayNew(1) />
    <cfset var resObj = {}>
    <cfset resObj["data"] = SerializeJSON(returnArray)>
    <cfreturn resObj>
  </cffunction>

  <cffunction name="createError" access="public" output="false" hint="Create error" returntype="boolean">
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
