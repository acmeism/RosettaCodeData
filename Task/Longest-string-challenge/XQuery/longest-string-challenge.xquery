let $seq as xs:string+ := ("a","bb","ccc","ddd","ee","f","ggg")
for $l in max(
               for $s in $seq
               return string-length($s)
             )
return $seq[string-length(.) eq $l]
