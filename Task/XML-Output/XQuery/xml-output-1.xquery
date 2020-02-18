let $names := ("April","Tam O'Shanter","Emily")
let $remarks := ("Bubbly: I'm > Tam and <= Emily", 'Burns: "When chapman billies leave the street ..."',"Short &amp; shrift")
return element CharacterRemarks {
                                  for $name at $count in $names
                                  return element Character {
                                                             attribute name { $name }
                                                            ,text { $remarks[$count] }
                                                            }
                                }
