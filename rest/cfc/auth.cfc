
<cfcomponent hint="Auth functions" displayname="auth">

  <!--- User Login --->
  <cffunction name="loginUser" access="public" output="false" hint="Login User" returntype="struct">

    <cfargument name="login" required="true" type="string" />
    <cfargument name="password" type="string" required="true" />

    <cfset var resObj = {}>

    <cfquery datasource="db" name="userLogin">
      SELECT id, password_hash
      FROM users
      WHERE login = <cfqueryparam value="#login#" cfsqltype="cf_sql_varchar">
    </cfquery>


    <cfif userLogin.recordCount>
      <cfif userLogin.password_hash eq Hash(password, "SHA-256")>
        <cfset expdt =  dateAdd("n",60,now())>
        <cfset utcDate = dateDiff('s', dateConvert('utc2Local', createDateTime(1970, 1, 1, 0, 0, 0)), expdt) />

        <cfset jwt = new jwt(Application.jwtkey)>
        <cfset payload = {"iss" = "cf-api", "exp" = utcDate, "sub": "JWT Token", "userId": userLogin.id}>
        <cfset token = jwt.encode(payload)>

        <cfset resObj["status"] = true>
        <cfset resObj["token"] = token>
      <cfelse>
        <cfset resObj["status"] = false>
        <cfset resObj["message"] = "Incorrect password">
      </cfif>
    <cfelse> <!--- if user credentials are invalid --->
      <cfset resObj["status"] = false>
      <cfset resObj["message"] = "Incorrect login">
    </cfif>

    <cfreturn resObj>

  </cffunction>


  <cffunction name="logoutUser" returnType="struct" access="public" hint="Logout user">

  </cffunction>

</cfcomponent>
