$ jq -n --arg stones aAAbbbb --arg jewels aA '
  [$stones|split("") as $s|$jewels|split("") as $j|$s[]|
  select(. as $c|$j|contains([$c]))]|length'
