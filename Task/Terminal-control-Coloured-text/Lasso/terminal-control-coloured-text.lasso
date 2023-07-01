#!/usr/bin/lasso9

define ec(code::string) => {

	local(esc		= decode_base64('Gw=='))
	local(codes		= map('esc' = #esc,
		'normal'	= #esc + '[0m',
		'blink'		= #esc + '[5;31;49m',
		'red'		= #esc + '[31;49m',
		'blue'		= #esc + '[34;49m',
		'green'		= #esc + '[32;49m',
		'magenta'	= #esc + '[35;49m',
		'yellowred'	= #esc + '[33;41m'
	))

	return #codes -> find(#code)
}

stdout( ec('red'))
stdoutnl('So this is the Rosetta Code!')
stdout( ec('blue'))
stdoutnl('So this is the Rosetta Code!')
stdout( ec('green'))
stdoutnl('So this is the Rosetta Code!')
stdout( ec('magenta'))
stdoutnl('So this is the Rosetta Code!')
stdout( ec('yellowred'))
stdout('So this is the Rosetta Code!')
stdoutnl( ec('blink'))
stdoutnl('So this is the Rosetta Code!')
stdout( ec('normal'))
