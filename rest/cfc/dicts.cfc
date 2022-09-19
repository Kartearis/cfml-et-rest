
<cfcomponent hint="Dict functions" displayname="dicts">

  <cffunction name="getDict" access="private" output="false" hint="Helper function to retrieve dict"
    returntype="array">
    <cfargument name="table" required="true" type="string">
    <cfset returnArray = ArrayNew(1) />
    <cfquery name="dicts" datasource="db">
      SELECT id, name FROM #table#
    </cfquery>
    <cfloop query="dicts">
      <cfset ArrayAppend(returnArray, {"id": #id#, "name": #name#}) />
    </cfloop>
    <cfreturn returnArray>
  </cffunction>

  <cffunction name="getStates" access="public" output="false" hint="Get all states" returntype="string">
    <cfreturn SerializeJSON(getDict("dict_defect_state"))>
  </cffunction>

  <cffunction name="getLevels" access="public" output="false" hint="Get all levels" returntype="string">
    <cfreturn SerializeJSON(getDict("dict_defect_level"))>
  </cffunction>

  <cffunction name="getUrgency" access="public" output="false" hint="Get all urgencies" returntype="string">
    <cfreturn SerializeJSON(getDict("dict_defect_urgency"))>
  </cffunction>



</cfcomponent>
