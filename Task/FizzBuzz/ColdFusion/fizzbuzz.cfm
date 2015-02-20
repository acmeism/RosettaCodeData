<Cfloop from="1" to="100" index="i">
  <Cfif i mod 15 eq 0>FizzBuzz
  <Cfelseif i mod 5 eq 0>Fizz
  <Cfelseif i mod 3 eq 0>Buzz
  <Cfelse><Cfoutput>#i#</Cfoutput>
  </Cfif>
</Cfloop>
