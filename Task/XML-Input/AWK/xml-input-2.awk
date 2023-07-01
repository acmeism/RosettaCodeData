awk -f getXML.awk sample.xml | awk '
    $1 == "TAG"                 {tag = $2}
    tag == "Student" && /Name=/ {print substr($0, index($0, "=") + 1)}
'
