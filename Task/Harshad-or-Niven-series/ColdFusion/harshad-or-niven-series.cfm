<Cfset harshadNum = 0>
<Cfset counter = 0>

<Cfloop condition="harshadNum lte 1000">

  <Cfset startnum = harshadNum + 1>
  <Cfset digits = 0>
  <Cfset harshad = 0>

  <Cfloop condition="Harshad eq 0">

    <Cfset current_i = startnum>
    <Cfset digits = 0>

    <cfloop condition="len(current_i) gt 1">
      <Cfset digit = left(current_i, 1)>
      <Cfset current_i = right(current_i, len(current_i)-1)>
      <Cfset digits = digits + digit>
    </cfloop>
    <Cfset digits = digits + current_i>

    <Cfif Startnum MOD digits eq 0>
      <Cfset harshad = 1>
    <Cfelse>
      <cfset startnum = startnum + 1>
    </Cfif>

  </Cfloop>

  <cfset harshadNum = startnum>
  <Cfset counter = counter + 1>

  <Cfif counter lte 20>
    <Cfoutput>#harshadNum# </Cfoutput>
  </Cfif>

</Cfloop>

<Cfoutput>... #harshadNum# </Cfoutput>
