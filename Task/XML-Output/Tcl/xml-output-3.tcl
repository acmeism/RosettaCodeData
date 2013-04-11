package require dom
set xml [dom::DOMImplementation create]
set root [dom::document createElement $xml CharacterRemarks]
foreach {name comment} {
    April "Bubbly: I'm > Tam and <= Emily"
    "Tam O'Shanter" "Burns: \"When chapman billies leave the street ...\""
    Emily "Short & shrift"
} {
    set element [dom::document createElement $root Character]
    dom::element setAttribute $element name $name
    dom::document createTextNode $element $comment
}
dom::DOMImplementation serialize $xml -indent 1
