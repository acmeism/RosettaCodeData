gawk -f xmlparser.awk sample.xml | awk '
    $1 == "begin"                                         {tag = $2}
    $1 == "attrib"                                        {attrib = $2}
    $1 == "value" && tag == "STUDENT" && attrib == "name" {print $2}
'
