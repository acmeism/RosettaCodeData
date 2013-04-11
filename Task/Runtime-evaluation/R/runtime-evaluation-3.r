> env <- as.environment(list(a=1, b=3, c=2))
> evalq(a, env)
[1] 1
> eval(expr1, env) #this fails; env has only emptyenv() as a parent so can't find "+"
Error in eval(expr, envir, enclos) : could not find function "+"
> parent.env(env) <- sys.frame()
> eval(expr1, env) # eval in env, enclosed in the current context
[1] 7
> assign("b", 5, env) # assign() can assign into environments
> eval(expr1, env)
[1] 11
