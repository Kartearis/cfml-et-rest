<cfcomponent rest="true" restpath="/">

  <cfobject name="objUsers" component="cfc.users">
  <cfobject name="objAuth" component="cfc.auth">
  <cfobject name="objErrors" component="cfc.errors">
  <cfobject name="objHistory" component="cfc.history">
  <cfobject name="objDicts" component="cfc.dicts">

  <!--- Function to validate token--->
  <cffunction name="authenticate" returntype="any">

    <cfset var response = {}>
    <cfset requestData = GetHttpRequestData()>
    <cfif StructKeyExists( requestData.Headers, "authorization" )>
      <cfset token = GetHttpRequestData().Headers.authorization>
      <cftry>
        <cfset jwt = new cfc.jwt(Application.jwtkey)>
        <cfset result = jwt.decode(token)>
        <cfset response["success"] = true>
        <cfcatch type="Any">
          <cfset response["success"] = false>
          <cfset response["message"] = cfcatch.message>
          <cfreturn response>
        </cfcatch>
      </cftry>
    <cfelse>
      <cfset response["success"] = false>
      <cfset response["message"] = "Authorization token invalid or not present.">
    </cfif>
    <cfreturn response>

  </cffunction>

  <!--- User Login--->
  <cffunction name="login" restpath="auth/login" access="remote" returntype="void" httpmethod="POST" produces="application/json">
    <cfargument name="login" type="any" required="yes" restargsource="query">
    <cfargument name="password" type="any" required="yes" restargsource="query">

    <cfset var response = {status: 200, content: ""}>
    <cfset res = objAuth.loginUser(login, password)>
    <cfif res.status eq true>
      <cfset response.status = 200>
      <cfset response.content = res>
    <cfelse>
      <cfset response.status = 422>
      <cfset response.content = res.message>
    </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="getuser" restpath="users/{id}" access="remote" returntype="void" httpmethod="GET" produces="application/json">

    <cfargument name="id" type="any" required="yes" restargsource="path"/>

    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
    <cfif not verify.success>
      <cfset response.status=401>
      <cfset response.content = verify.message>
    <cfelse>
      <cfset res = objUsers.getUser(id)>
      <cfif res.status eq true>
        <cfset response.content = res.data>
      <cfelse>
        <cfset response.status=404>
        <cfset response.content = res.message>
      </cfif>
    </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="getusers" restpath="users" access="remote" returntype="void" httpmethod="GET" produces="application/json">

    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
    <cfif not verify.success>
      <cfset response.status=401>
      <cfset response.content = verify.message>
    <cfelse>
      <cfset response.content = objUsers.getUsers()>
    </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="createuser" restpath="users" access="remote" returntype="void" httpmethod="POST" produces="application/json">
    <cfargument name="name" type="any" required="yes" restargsource="query"/>
    <cfargument name="surname" type="any" required="yes" restargsource="query"/>
    <cfargument name="login" type="any" required="yes" restargsource="query"/>
    <cfargument name="password" type="any" required="yes" restargsource="query"/>

    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
    <cfif not verify.success>
      <cfset response.status=401>
      <cfset response.content = verify.message>
    <cfelse>
      <cfset res = objUsers.createUser(name, surname, login, password)>
      <cfif res.status eq true>
        <cfset response.status = 201>
        <cfset response.content = res>
      <cfelse>
        <cfset response.status = 422>
        <cfset response.content = "Could not create user">
      </cfif>
    </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="updateuser" restpath="users/{id}" access="remote" returntype="void" httpmethod="PATCH" produces="application/json">
    <cfargument name="id" type="any" required="yes" restargsource="path"/>
    <cfargument name="name" type="any" required="yes" restargsource="query"/>
    <cfargument name="surname" type="any" required="yes" restargsource="query"/>

    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
    <cfif not verify.success>
      <cfset response.status=401>
      <cfset response.content = verify.message>
    <cfelse>
      <cfset res = objUsers.updateUser(id, name, surname)>
      <cfif res.status eq true>
        <cfset response.status = 200>
        <cfset response.content = res>
      <cfelse>
        <cfset response.status = 422>
        <cfset response.content = "Could not update user">
      </cfif>
    </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="geterrors" restpath="errors" access="remote" returntype="void" httpmethod="GET" produces="application/json">
    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
    <cfif not verify.success>
      <cfset response.status=401>
      <cfset response.content = verify.message>
    <cfelse>
      <cfset response.content = objErrors.getErrors()>
    </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="geterror" restpath="errors/{id}" access="remote" returntype="void" httpmethod="GET" produces="application/json">
    <cfargument name="id" type="any" required="yes" restargsource="path"/>

    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
    <cfif not verify.success>
      <cfset response.status=401>
      <cfset response.content = verify.message>
    <cfelse>
      <cfset res = objErrors.getError(id)>
      <cfif res.status eq true>
        <cfset response.content = res.data>
      <cfelse>
        <cfset response.status=404>
        <cfset response.content = res.message>
      </cfif>
    </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="createError" restpath="errors" access="remote" returntype="void" httpmethod="POST" produces="application/json">
    <cfargument name="shortDescription" type="any" required="yes" restargsource="form"/>
    <cfargument name="description" type="any" required="yes" restargsource="form"/>
    <cfargument name="level_id" type="any" required="yes" restargsource="form"/>
    <cfargument name="urgency_id" type="any" required="yes" restargsource="form"/>

    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
    <cfif not verify.success>
      <cfset response.status=401>
      <cfset response.content = verify.message>
    <cfelse>
      <cfset res = objErrors.createError(shortDescription, description, level_id, urgency_id)>
      <cfif res.status eq true>
        <cfset response.status = 201>
        <cfset response.content = res>
      <cfelse>
        <cfset response.status = 422>
        <cfset response.content = res.message>
      </cfif>
    </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="updateerror" restpath="errors/{id}" access="remote" returntype="void" httpmethod="POST" produces="application/json">
    <cfargument name="id" type="any" required="yes" restargsource="path"/>
    <cfargument name="description" type="any" required="yes" restargsource="form"/>
    <cfargument name="shortDescription" type="any" required="yes" restargsource="form"/>
    <cfargument name="state_id" type="any" required="yes" restargsource="form"/>
    <cfargument name="level_id" type="any" required="yes" restargsource="form"/>
    <cfargument name="urgency_id" type="any" required="yes" restargsource="form"/>
    <cfargument name="comment" type="any" required="yes" restargsource="form"/>

    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
    <cfif not verify.success>
      <cfset response.status=401>
      <cfset response.content = verify.message>
    <cfelse>
      <!--- <cfset res = {status:true}> --->
      <cfset res = objErrors.updateError(id, shortDescription, description, state_id, level_id, urgency_id, comment) >
      <cfif res.status eq true>
        <cfset response.status = 200>
        <cfset response.content = res>
      <cfelse>
        <cfset response.status = 422>
        <cfset response.content = res.message>
      </cfif>
    </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="gethistory" restpath="errors/{id}/history" access="remote" returntype="void" httpmethod="GET" produces="application/json">
    <cfargument name="id" type="any" required="yes" restargsource="path"/>
    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
      <cfif not verify.success>
        <cfset response.status=401>
        <cfset response.content = verify.message>
      <cfelse>
        <cfset response.content = objHistory.getErrorHistory(id).data>
      </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="appendhistory" restpath="errors/{id}/history" access="remote" returntype="void" httpmethod="POST" produces="application/json">
    <cfargument name="id" type="any" required="yes" restargsource="path"/>
    <cfargument name="action" type="any" required="yes" restargsource="form"/>
    <cfargument name="comment" type="any" required="yes" restargsource="form"/>

    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
    <cfif not verify.success>
      <cfset response.status=401>
      <cfset response.content = verify.message>
    <cfelse>
      <cfset res = objHistory.appendErrorHistory(id, action, comment)>
      <cfif res.status eq true>
        <cfset response.status = 201>
        <cfset response.content = res>
      <cfelse>
        <cfset response.status = 422>
        <cfset response.content = res.message>
      </cfif>
    </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="getstates" restpath="dicts/states" access="remote" returntype="void" httpmethod="GET" produces="application/json">

    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
      <cfif not verify.success>
        <cfset response.status=401>
        <cfset response.content = verify.message>
      <cfelse>
        <cfset response.content = objDicts.getStates()>
      </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="getlevels" restpath="dicts/levels" access="remote" returntype="void" httpmethod="GET" produces="application/json">

    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
      <cfif not verify.success>
        <cfset response.status=401>
        <cfset response.content = verify.message>
      <cfelse>
        <cfset response.content = objDicts.getLevels()>
      </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

  <cffunction name="geturgencies" restpath="dicts/urgency" access="remote" returntype="void" httpmethod="GET" produces="application/json">

    <cfset var response = {status: 200, content: ""}>
    <cfset verify = authenticate()>
      <cfif not verify.success>
        <cfset response.status=401>
        <cfset response.content = verify.message>
      <cfelse>
        <cfset response.content = objDicts.getUrgency()>
      </cfif>

    <cfset restSetResponse(response) />
  </cffunction>

</cfcomponent>
