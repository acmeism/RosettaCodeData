x <- "global x"
print(x)                                   #"global x"

local({ ## local({...}) is a shortcut for evalq({...}, envir=new.env())
        ## and is also equivalent to (function() {...})()

  x <- "outer local x"
  print(x)                                 #"outer local x"
  x <<- "modified global x"
  print(x)                                 #"outer local x" still
  y <<- "created global y"
  print(y)                                 #"created global y"
  local({

    ## Note, <<- is _not_ a global assignment operator. If an
    ## enclosing scope defines the variable, that enclosing scope gets
    ## the assignment. This happens in the order of evalution; a local
    ## variable may be defined later on in the same scope.

    x <- "inner local x"
    print(x)                               #"inner local x"
    x <<- "modified outer local x"
    print(x)                               #"inner local x"
    y <<- "modified global y"
    print(y)                               #"modified global y"
    y <- "local y"
    print(y)                               #"local y"

    ##this is the only way to reliably do a global assignment:
    assign("x", "twice modified global x", globalenv())
    print(evalq(x, globalenv()))           #"twice modified global x"
  })

  print(x)                                 #"modified outer local x"
})
print(x)                                   #"twice modified global x"
print(y)                                   #"modified global y"
