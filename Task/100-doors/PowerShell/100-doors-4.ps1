$doors = 1..100 | ForEach-Object {0}
$visited = 1..100
1..100 | ForEach-Object { $a=$_;$visited[0..([math]::floor(100/$a)-1)] | Where-Object { -not ( $_ % $a )  } | ForEach-Object { $doors[$_-1] = $doors[$_-1] -bxor 1;$visited[$_/$a-1]+=($_/$a) }; if ( $doors[$a-1] ) { "door opened" } else { "door closed" } }
