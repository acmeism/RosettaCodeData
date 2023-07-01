csv2html() {
    IFS=,
    echo "<table>"

    echo "<thead>"
    read -a fields
    htmlrow th "${fields[@]}"
    echo "</thead>"

    echo "<tbody>"
    while read -a fields
    do htmlrow td "${fields[@]}"
    done
    echo "</tbody>"
    echo "</table>"
}

htmlrow() {
  cell=$1
  shift
  echo "<tr>"
  for field
  do echo "<$cell>$(escape_html "$field")</$cell>"
  done
  echo "</tr>"
}

escape_html() {
    str=${1//\&/&amp;}
    str=${str//</&lt;}
    str=${str//>/&gt;}
    echo "$str"
}

csv2html <<-END
Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!
END
