#!/usr/bin/lasso9

local(esc		= decode_base64('Gw=='))

stdoutnl('Demonstrate how to move the cursor one position to the left
Demonstrate how to move the cursor one position to the right
Demonstrate how to move the cursor up one line (without affecting its horizontal position)
Demonstrate how to move the cursor down one line (without affecting its horizontal position)
Demonstrate how to move the cursor to the beginning of the line
Demonstrate how to move the cursor to the end of the line
Demonstrate how to move the cursor to the top left corner of the screen
Demonstrate how to move the cursor to the bottom right corner of the screen
')

// place cursor in a suitable place before exercise
stdout(#esc + '[5;10H')
sleep(2000)


// move the cursor one position to the left
stdout(#esc + '[1D')
sleep(2000)

// move the cursor one position to the right
stdout(#esc + '[1C')
sleep(2000)

// move the cursor up one line
stdout(#esc + '[1A')
sleep(2000)

// move the cursor down one line
stdout(#esc + '[1B')
sleep(2000)

// move the cursor to the beginning of the line
stdout(#esc + '[100D')
sleep(2000)

// move the cursor to the top left corner of the screen
stdout(#esc + '[H')
sleep(2000)

// move the cursor to the bottom right corner of the screen
stdout(#esc + '[500;500H')
sleep(2000)
