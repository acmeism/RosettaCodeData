  funName = 'foo';   % generate function name
  feval (funNAME, ...)  % evaluation function with optional parameters

  funName = 'a=atan(pi)';   % generate function name
  eval (funName, 'printf(''Error\n'')')
