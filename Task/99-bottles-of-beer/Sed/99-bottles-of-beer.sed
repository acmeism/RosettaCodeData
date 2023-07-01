s/.*/99 bottles of beer on the wall/
h
: b
s/^0//
/^0/q
s/^1 bottles/1 bottle/
p
s/on.*//
p
s/.*/Take one down, pass it around/
p
g
/^.[1-9]/{
h
s/^.//
y/123456789/012345678/
x
s/^\(.\).*$/\1/
G
s/\n//
h
bb
}
y/0123456789/9012345678/
h
bb
