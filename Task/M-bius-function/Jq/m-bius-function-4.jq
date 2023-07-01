def isSquareFree:
  . as $n
  | 2
  | until ( (. * . > $n) or . == 0;
       if ($n % (.*.) == 0) then 0 # i.e. stop
       elif . > 2 then . + 2
       else . + 1
       end  )
  | . != 0;

def mu:
  . as $n
  | if . < 1 then "Argument to mu must be a positive integer" | error
    elif . == 1 then 1
    else if isSquareFree
         then if ((prime_factors|length) % 2 == 0) then 1
              else -1
              end
         else 0
         end
    end;
