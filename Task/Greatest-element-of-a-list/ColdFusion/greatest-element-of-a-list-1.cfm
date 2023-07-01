<Cfset theList = '1, 1000, 250, 13'>
<Cfparam name="maxNum" default=0>
<Cfloop list="#theList#" index="i">
  <Cfif i gt maxNum><Cfset maxNum = i></Cfif>
</Cfloop>
<Cfoutput>#maxNum#</Cfoutput>
