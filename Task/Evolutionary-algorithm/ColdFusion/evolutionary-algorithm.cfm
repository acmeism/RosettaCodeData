<Cfset theString = 'METHINKS IT IS LIKE A WEASEL'>
<cfparam name="parent" default="">
<Cfset theAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ">
<Cfset fitness = 0>
<Cfset children = 3>
<Cfset counter = 0>

<Cfloop from="1" to="#children#" index="child">
  <Cfparam name="child#child#" default="">
  <Cfparam name="fitness#child#" default=0>
</Cfloop>

<Cfloop condition="fitness lt 1">

  <Cfset oldparent = parent>
  <Cfset counter = counter + 1>

  <cfloop from="1" to="#children#" index="child">
    <Cfset thischild = ''>

    <Cfloop from="1" to="#len(theString)#" index="i">
      <cfset Mutate = Mid(theAlphabet, RandRange(1, 28), 1)>
      <cfif fitness eq 0>
        <Cfset thischild = thischild & mutate>
      <Cfelse>

        <Cfif Mid(theString, i, 1) eq Mid(variables["child" & child], i, 1)>
          <Cfset thischild = thischild & Mid(variables["child" & child], i, 1)>
        <Cfelse>
          <cfset MutateChance = 1/fitness>
          <Cfset MutateChanceRand = rand()>
          <Cfif MutateChanceRand lte MutateChance>
            <Cfset thischild = thischild & mutate>
          <Cfelse>
            <Cfset thischild = thischild & Mid(variables["child" & child], i, 1)>
          </Cfif>
        </Cfif>

      </cfif>
    </Cfloop>

    <Cfset variables["child" & child] = thischild>

</cfloop>

  <cfloop from="1" to="#children#" index="child">
    <Cfset thisChildFitness = 0>
    <Cfloop from="1" to="#len(theString)#" index="i">
      <Cfif Mid(variables["child" & child], i, 1) eq Mid(theString, i, 1)>
        <Cfset thisChildFitness = thisChildFitness + 1>
      </Cfif>
    </Cfloop>

    <Cfset variables["fitness" & child] = (thisChildFitness)/len(theString)>

    <Cfif variables["fitness" & child] gt fitness>
      <Cfset fitness = variables["fitness" & child]>
      <Cfset parent = variables["child" & child]>
    </Cfif>

  </cfloop>

  <Cfif parent neq oldparent>
    <Cfoutput>###counter# #numberformat(fitness*100, 99)#% fit: #parent#<br></Cfoutput><cfflush>
  </Cfif>

</Cfloop>
