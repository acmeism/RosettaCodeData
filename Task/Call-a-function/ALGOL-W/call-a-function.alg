% Note, in Algol W, functions are called procedures %
% calling a function with no parameters: %
f;

% calling a function with a fixed number of parameters %
g( 1, 2.3, "4" );

% Algol W does not support optional parameters in general, however constructors for records can %
% be called wither with parameters (one for each field in the record) or no parameters #

% Algol W does not support variable numbers of parameters, except for the built-in I/O functions #
% Algol W does not support named arguments %

% A function can be used in a statement context by calling it, as in the examples above %

% First class context: A function can be passed as a parameter to another procedure, e.g.: %
v := integrate( sin, 0, 1 )
% assuming a suitable definition of integrate %
% Algol W does not support functions returning functions %

% obtaining the return value of a function: e.g.: %
v := g( x, y, z );

% There is no syntactic distinction between user-defined and built-in functions %

% Subroutines and functions are both procedures, a subroutine is a procedure with no return type %
% (called a proper procedure in Algol W) %
% There is no syntactic distinction between a call to a function and a call to a subroutine %
% other than the context %

% In Algol W, parameters are passed by value, result or value result. This must be stated in the %
% definition of the function/subroutine. Value parameters are passed by value, result and value result %
% are effectively passed by reference and assigned on function exit. Result parameters are "out" parameters %
% and value result parameters are "in out". %
% Algol W also has "name" parameters (not to be confused with named parameters). Functions with name %
% parameters are somewhat like macros %

% Partial application is not possible in Algol W %
