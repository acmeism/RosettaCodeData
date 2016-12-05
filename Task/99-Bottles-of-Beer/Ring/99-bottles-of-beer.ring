for i = 99 to 0 step -1
switch i
on 0
see "No more bottles of beer on the wall,
no more bottles of beer.
Go to the store and buy some more, 99 bottles of beer on the wall."
on 1
see "1 bottle of beer on the wall,
1 bottle of beer.
Take one down and pass it around,
No more bottles of beer on the wall.

"
other
see string(i) + " bottles of beer on the wall,
" + string(i) + " bottles of beer.
Take one down and pass it around,
" + string(i-1) + " bottles of beer on the wall.

"
off
next
