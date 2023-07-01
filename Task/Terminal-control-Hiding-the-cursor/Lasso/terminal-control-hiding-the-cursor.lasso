#!/usr/bin/lasso9

local(
	esc = decode_base64('Gw==')
)

// hide the cursor
stdout(#esc + '[?25l')

// wait for 4 seconds to give time discover the cursor is gone
sleep(4000)

// show the cursor
stdout(#esc + '[?25h')

// wait for 4 seconds to give time discover the cursor is back
sleep(4000)
