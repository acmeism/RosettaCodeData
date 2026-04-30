-- yet another version:

include std/console.e

object stanza = {
"[] bottles of beer on the wall,",
"[] bottles of beer,",
"take one down, and pass it around,"
}

object bottles = 99

loop do
    display(stanza[1],bottles)
    display(stanza[2],bottles)
    display(stanza[3])
    bottles -= 1
    display(stanza[1]&"\n",{bottles})
until bottles = 0
end loop
