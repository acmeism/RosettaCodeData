<Cfparam name="doorlist" default="">
<cfloop from="1" to="100" index="i">
	<Cfset doorlist = doorlist & 'c,'>
</cfloop>
<cfloop from="1" to="100" index="i">
	<Cfloop from="1" to="100" index="door" step="#i#">
  	<Cfif listgetat(doorlist, door) eq 'c'>
    	<Cfset doorlist = listsetat(doorlist, door, 'O')>
    <Cfelse>
    	<Cfset doorlist = listsetat(doorlist, door, 'c')>
    </Cfif>
  </Cfloop>
</cfloop>
<Cfoutput>#doorlist#</Cfoutput>
