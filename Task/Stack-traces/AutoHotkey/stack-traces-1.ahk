f()
return

f()
{
return g()
}

g()
{
ListLines
msgbox, lines recently executed
x = local to g
ListVars
msgbox, variable bindings
}
#Persistent
