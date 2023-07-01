(: Sequence of numbers from 1 to 10 :)
let $array := (1 to 10)

(: Short version :)
let $short := $array[. mod 2 = 0]

(: Long version with a FLWOR expression :)
let $long := for $value in $array
             where $value mod 2 = 0
             return $value

(: Show the results :)
return
  <result>
    <short>{$short}</short>
    <long>{$long}</long>
  </result>
