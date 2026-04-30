$doors = 1..100 | ForEach-Object {0}
1..100 | ForEach-Object { $a=$_;1..100 | Where-Object { -not ( $_ % $a )  } | ForEach-Object { $doors[$_-1] = $doors[$_-1] -bxor 1 }; if ( $doors[$a-1] ) { "door opened" } else { "door closed" } }
