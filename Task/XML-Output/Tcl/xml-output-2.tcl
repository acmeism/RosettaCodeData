package require tdom
set xml [dom createDocument CharacterRemarks]
foreach {name comment} {
    April "Bubbly: I'm > Tam and <= Emily"
    "Tam O'Shanter" "Burns: \"When chapman billies leave the street ...\""
    Emily "Short & shrift"
} {
    set elem [$xml createElement Character]
    $elem setAttribute name $name
    $elem appendChild [$xml createTextNode $comment]
    [$xml documentElement] appendChild $elem
}
$xml asXML
