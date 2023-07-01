<Cfset randNum = 0>
<cfloop condition="randNum neq 10">
  <Cfset randNum = RandRange(0, 19)>
  <Cfoutput>#randNum#</Cfoutput>
  <Cfif randNum eq 10><cfbreak></Cfif>
  <Cfoutput>#RandRange(0, 19)#</Cfoutput>
  <Br>
</cfloop>
