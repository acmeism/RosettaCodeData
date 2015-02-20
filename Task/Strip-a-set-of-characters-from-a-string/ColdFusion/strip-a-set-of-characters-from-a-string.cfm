<Cfset theString = 'She was a soul stripper. She took my heart!'>
<Cfset theStrip = 'aei'>
<Cfloop from="1" to="#len(theStrip)#" index="i">
  <cfset theString = replace(theString, Mid(theStrip, i, 1), '', 'all')>
</Cfloop>
<Cfoutput>#theString#</Cfoutput>
