declare
Var         %% new variable Var, initially free
{Show Var}
Var = 42    %% now Var has the value 42
{Show Var}
Var = 42    %% the same value is assigned again: ok
Var = 43    %% a different value is assigned: exception
