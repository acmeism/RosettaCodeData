<cfscript>
result = "";
  for(i=1;i<=100;i++){
   result=ListAppend(result, (i%15==0) ? "FizzBuzz": (i%5==0) ? "Buzz" : (i%3 eq 0)? "Fizz" : i );
  }
  WriteOutput(result);
</cfscript>
