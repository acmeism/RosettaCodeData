# Input should be an array
def extract:
  reduce .[] as $i
    # state is an array with integers or [start, end] ranges
    ([];
     if length == 0 then [ $i ]
     else ( .[-1]) as $last
            | if ($last|type) == "array" then
                if ($last[1] + 1) == $i then setpath([-1,1]; $i)
                else . + [ $i ]
                end
              elif ($last + 1) == $i then setpath([-1]; [$last, $i])
              else . + [ $i ]
              end
     end)
     | map( if type == "number" then tostring
       elif .[0] == .[1] -1
         then  "\(.[0]),\(.[1])"  # satisfy special requirement
       else "\(.[0])-\(.[1])" end )
     | join(",") ;
