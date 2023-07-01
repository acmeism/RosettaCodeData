USE: wrap.strings
IN: scratchpad "Most languages in widespread use today are applicative languages
: the central construct in the language is some form of function call, where a f
unction is applied to a set of parameters, where each parameter is itself the re
sult of a function call, the name of a variable, or a constant. In stack languag
es, a function call is made by simply writing the name of the function; the para
meters are implicit, and they have to already be on the stack when the call is m
ade. The result of the function call (if any) is then left on the stack after th
e function returns, for the next function to consume, and so on. Because functio
ns are invoked simply by mentioning their name without any additional syntax, Fo
rth and Factor refer to functions as words, because in the syntax they really ar
e just words." [ 60 wrap-string print nl ] [ 45 wrap-string print ] bi
