gcc -std=c2x -Wall -Wextra \
    -I/usr/include/lua5.3 -o query  \
    Query.c Query_lua.c \
    -L/usr/lib/x84_64-linux-gnu/ -l lua5.3
