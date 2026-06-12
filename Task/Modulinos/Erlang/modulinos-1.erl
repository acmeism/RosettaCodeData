all: t

t: scriptedmain.beam test.beam
	erl -noshell -s scriptedmain
	erl -noshell -s test

scriptedmain.beam: scriptedmain.erl
	erlc scriptedmain.erl

test.beam: test.erl
	erlc test.erl

clean:
	-rm *.beam
