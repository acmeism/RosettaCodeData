// Display all doors
<cfloop from="1" to="100" index="x">
    Door #x# Open: #YesNoFormat(ListGetAt(doorList,x))#<br />
</cfloop>

// Output only open doors
<cfloop from="1" to="100" index="x">
    <cfif ListGetAt(doorList,x) EQ 1>
        #x#<br />
    </cfif>
</cfloop>
