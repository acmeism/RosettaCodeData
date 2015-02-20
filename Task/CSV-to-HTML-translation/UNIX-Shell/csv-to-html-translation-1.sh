csv2html() {
    IFS=,
    echo "<table>"

    echo "<thead>"
    read -r speaker text
    htmlrow "$speaker" "$text" th
    echo "</thead>"

    echo "<tbody>"
    while read -r speaker text; do
        htmlrow "$speaker" "$text"
    done
    echo "</tbody>"
    echo "</table>"
}

htmlrow() {
    cell=${3:-td}
    printf "<tr><%s>%s</%s><%s>%s</%s></tr>\n" \
        "$cell" "$(escape_html "$1")" "$cell" \
        "$cell" "$(escape_html "$2")" "$cell"
}

escape_html() {
    str=${1//\&/&amp;}
    str=${str//</&lt;}
    str=${str//>/&gt;}
    echo "$str"
}

html=$(
    csv2html <<-END
	Character,Speech
	The multitude,The messiah! Show us the messiah!
	Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
	The multitude,Who are you?
	Brians mother,I'm his mother; that's who!
	The multitude,Behold his mother! Behold his mother!
	END
)
echo "$html"
