
<cfcomponent hint="History specific functions" displayname="Error history">


  <!--- User Details --->
  <cffunction name="getErrorHistory" access="public" output="false" hint="Get history for error" returntype="struct">
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

  <cffunction name="appendErrorHistory" access="public" output="false" hint="Add entry to error history" returntype="boolean">
    <cfargument name="errorId" required="true" type="numeric" />
    <cfargument name="action" required="true" type="numeric" />
    <cfargument name="comment" required="true" type="string" />

    <cfreturn true>
  </cffunction>


</cfcomponent>
