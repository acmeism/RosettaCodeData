<cfoutput>
<cfset str = "Hello World">
<cfset j = createObject("java","java.lang.String").init(str)>
<cfset t = j.getBytes()>
<p>#arrayLen(t)#</p>
</cfoutput>
