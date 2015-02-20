#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

# An explanation of any placement restrictions for prototype declarations #
PROC VOID no args; # Declare a function with no argument that returns an INTeger #
PROC (INT #a#,INT #b#)VOID two args; # Declare a function with two arguments that returns an INTeger #
MODE VARARGS = UNION(INT,REAL,COMPL);
PROC ([]VARARGS)VOID var args; # An empty parameter list can be used to declare a function that accepts varargs #
PROC (INT, []VARARGS)VOID at least one args; # One mandatory INTeger argument followed by varargs #

MODE OPTINT = UNION(VOID,INT), OPTSTRING=UNION(VOID,STRING); # a function that utilizes optional arguments #
PROC (OPTINT, OPTSTRING)VOID optional arguments;

# A prototype declaration for a function that utilizes named parameters #
MODE KWNAME = STRUCT(STRING name),
     KWSPECIES = STRUCT(STRING species),
     KWBREED = STRUCT(STRING breed),
     OWNER=STRUCT(STRING first name, middle name, last name);

# due to the "Yoneda ambiguity" simple arguments must have an unique operator defined #
OP NAME = (STRING name)KWNAME: (KWNAME opt; name OF opt := name; opt),
   SPECIES = (STRING species)KWSPECIES: (KWSPECIES opt; species OF opt := species; opt),
   BREED = (STRING breed)KWBREED: (KWBREED opt; breed OF opt := breed; opt);

PROC ([]UNION(KWNAME,KWSPECIES,KWBREED,OWNER) #options#)VOID print pet;

# subroutines, and fuctions are procedures, so have the same prototype declarations #

# An explanation and example of any special forms of prototyping not covered by the above:  #
COMMENT
  If a function has no arguments, eg f,
  then it is not requied to pass it a "vacuum()" to call it, eg "f()" not correct!
  Rather is can be called without the () vacuum. eg "f"
  A GOTO "label" is equivalent to "PROC VOID label".
END COMMENT

SKIP
