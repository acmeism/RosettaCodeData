package require tdom
set d [dom createDocument root]
set root [$d documentElement]
$root appendChild [$d createElement element]
[$root firstChild] appendChild [$d createTextNode "Some text here"]
$d asXML
