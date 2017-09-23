exp
 | if   . == true then "true"
   elif . == false then "false"
   elif . == null  then "maybe"
   elif type == "string" then .
   else error("unexpected value: \(.)")
   end
