:- initialization(main, main).

main(Argv) :-
	opt_spec(Spec),
	opt_parse(Spec, Argv, Opts, _),	
	(
		member(help(true), Opts) -> show_help
		; maplist(format('~w~n'), Opts)
	).
		
show_help :-
	opt_spec(Spec),		
	opt_help(Spec, HelpText),
	write('Usage: swipl opts.pl <options>\n\n'),
	write(HelpText).
	
opt_spec([
	[opt(help),
		type(boolean),
		default(false),
		shortflags([h]),
		longflags([help]),
		help('Show Help')],
		
	[opt(noconnect),
		type(boolean),
		default(false),
		shortflags([n]),
		longflags([noconnect]),
		help('do not connect, just check server status')],
		
	[opt(server),
		type(atom),
		default('www.google.com'),
		shortflags([s]),
		longflags([server]),
		help('The server address.')],
		
	[opt(port),
		type(integer),
		default(5000),
		shortflags([p]),
		longflags([port]),
		help('The server port.')]	
]).
