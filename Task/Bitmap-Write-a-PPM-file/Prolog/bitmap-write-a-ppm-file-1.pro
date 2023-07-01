:- module(bitmapIO, [
	write_ppm_p6/2]).

:- use_module(library(lists)).

%write_ppm_p6(File,Bitmap)
write_ppm_p6(Filename,[[X,Y],Pixels]):-
	open(Filename,write,Output,[encoding(octet)]),
	%write p6 header
	writeln(Output, 'P6'),
	atomic_list_concat([X, Y], ' ', Dimensions),
	writeln(Output, Dimensions),
	writeln(Output, '255'),
	%write bytes
	maplist(maplist(maplist(put_byte(Output))),Pixels),
	close(Output).
