def flatten:
   reduce .[] as $i
     ([];
     if $i | type == "array" then . + ($i | flatten)
     else . + [$i]
     end);
