#!/bin/bash

# Produce lines of the form: URI TITLE
function titles {
    local uri="http://www.rosettacode.org/mw/api.php?action=query&list=categorymembers"
    uri+="&cmtitle=Category:Programming_Tasks&cmlimit=5000&format=json"
    curl -Ss "$uri" |
      jq -r '.query.categorymembers[] | .title | "\(@uri) \(.)"'
}

# Syntax: count URI
function count {
    local uri="$1"
    curl -Ss "http://rosettacode.org/mw/index.php?title=${uri}&action=raw" |
      jq -R -n 'reduce (inputs|select(test("=={{header\\|"))) as $x(0; .+1)'
}

local n=0 i
while read uri title
do
    i=$(count "$uri")
    echo "$title: $i examples."
    n=$((n + i))
done < <(titles)
echo Total: $n examples.
