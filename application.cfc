<cfcomponent output="false">
  <cfdump var="sometext">

  <cfset this.name="cfrest">
  <cfset this.restsettings.cfclocation = "./">

  <cffunction name="onApplicationStart">
    <cfset Application.jwtkey="secretKey">

    <cfset restInitApplication(GetDirectoryFromPath(GetCurrentTemplatePath()) & 'rest', "controller")>
    <cfset this.restsettings.usehost=true/>
    <cfset this.restsettings.host="website-name.com"/>
  </cffunction>

  <cffunction name="onRequestStart" output="true">
    <cfif IsDefined("URL.reload") AND URL.reload EQ "reload">
      <cflock timeout="10" throwontimeout="No" type="Exclusive" scope="Application">
        <cfset onApplicationStart()>
      </cflock>
    </cfif>

    <cfheader name="Access-Control-Allow-Origin" value="*">
    <cfheader name="Access-Control-Allow-Methods" value="*">
    <cfheader name="Access-Control-Allow-Headers" value="*">
  </cffunction>
</cfcomponent>
