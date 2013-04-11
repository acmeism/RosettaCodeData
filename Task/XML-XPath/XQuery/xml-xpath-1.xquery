(:
  1. Retrieve the first "item" element
  Notice the braces around //item. This evaluates first all item elements and then retrieving the first one.
  Whithout the braces you get the first item for every section.
:)
let $firstItem := (//item)[1]

(: 2. Perform an action on each "price" element (print it out) :)
let $price := //price/data(.)

(: 3. Get an array of all the "name" elements  :)
let $names := //name

return
  <result>
    <firstItem>{$firstItem}</firstItem>
    <prices>{$price}</prices>
    <names>{$names}</names>
  </result>
