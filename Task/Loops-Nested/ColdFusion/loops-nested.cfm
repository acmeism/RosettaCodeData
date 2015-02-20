<Cfset RandNum = 0>
<Cfloop condition="randNum neq 20">
  <Cfloop from="1" to="5" index="i">
    <Cfset randNum = RandRange(1, 20)>
    <Cfoutput>#randNum# </Cfoutput>
    <Cfif RandNum eq 20><cfbreak></Cfif>
  </Cfloop>
  <br>
</Cfloop>
