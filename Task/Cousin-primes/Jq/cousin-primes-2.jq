# Use null as the EOS marker
foreach ((997|cousins),null) as $c (-1; .+1; if $c == null then "\nCount is \(.)" else $c end)
