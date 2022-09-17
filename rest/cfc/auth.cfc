
<cfcomponent hint="Auth functions" displayname="auth">

  <!--- User Login --->
  <cffunction name="loginUser" access="public" output="false" hint="Login User" returntype="struct">

    <cfargument name="login" required="true" type="string" />
    <cfargument name="password" type="string" required="true" />

    <cfset var resObj = {}>

    <!--- <cfquery> to check user credentials --->

    <cfif 1 eq 1> <!--- if user credentials are valid --->
      <cfset expdt =  dateAdd("n",30,now())>
      <cfset utcDate = dateDiff('s', dateConvert('utc2Local', createDateTime(1970, 1, 1, 0, 0, 0)), expdt) />

      <cfset jwt = new jwt(Application.jwtkey)>
      <cfset payload = {"iss" = "restdemo", "exp" = utcDate, "sub": "JWT Token", "userId": 223}>
      <cfset token = jwt.encode(payload)>

      <cfset resObj["success"] = true>
      <cfset resObj["message"] = "Login Successful">
      <cfset resObj["token"] = token>
    <cfelse> <!--- if user credentials are invalid --->
      <cfset resObj["success"] = false>
      <cfset resObj["message"] = "Incorrect login credentials.">
    </cfif>

    <cfreturn resObj>

  </cffunction>


  <cffunction name="logoutUser" returnType="struct" access="public" hint="Logout user">

  </cffunction>

</cfcomponent>
