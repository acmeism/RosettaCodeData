    % Calling a function that requires no arguments
       function a=foo();
         a=4;
       end;
       x = foo();
    % Calling a function with a fixed number of arguments
       function foo(a,b,c);
         %% function definition;
       end;
       foo(x,y,z);
    % Calling a function with optional arguments
       function foo(a,b,c);
	if nargin<2, b=0; end;
	if nargin<3, c=0; end;
         %% function definition;
       end;
       foo(x,y);
    % Calling a function with a variable number of arguments
       function foo(varargin);
	  for k=1:length(varargin)
            arg{k} = varargin{k};	
       end;
       foo(x,y);
    % Calling a function with named arguments
	%% does not apply
    % Using a function in statement context
	%% does not apply
    % Using a function in first-class context within an expression
    % Obtaining the return value of a function
       function [a,b]=foo();
         a=4;
         b='result string';
       end;
       [x,y] = foo();
    % Distinguishing built-in functions and user-defined functions
	fun = 'foo';	
	if (exist(fun,'builtin'))
 		printf('function %s is a builtin\n');
        elseif (exist(fun,'file'))
 		printf('function %s is user-defined\n');
        elseif (exist(fun,'var'))
 		printf('function %s is a variable\n');
        else
 		printf('%s is not a function or variable.\n');
        end
    % Distinguishing subroutines and functions
        % there are only scripts and functions, any function declaration starts with the keyword function, otherwise it is a script that runs in the workspace
    % Stating whether arguments are passed by value or by reference
      % arguments are passed by value, however Matlab has delayed evaluation, such that a copy of large data structures are done only when an element is written to.
