#!/usr/bin/env sml

let
	val program = CommandLine.name ()
in
	print ("Program: " ^ program ^ "\n")
end;
