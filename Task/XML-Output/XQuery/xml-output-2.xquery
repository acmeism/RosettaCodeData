let $names := ("April","Tam O'Shanter","Emily")
let $remarks := ("Bubbly: I'm > Tam and <= Emily", 'Burns: "When chapman billies leave the street ..."',"Short &amp; shrift")
return <CharacterRemarks>
       {
         for $name at $count in $names
         return <Character name='{$name}'> {$remarks[$count]} </Character>
       }
       </CharacterRemarks>
