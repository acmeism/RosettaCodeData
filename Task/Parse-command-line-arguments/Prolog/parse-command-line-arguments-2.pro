# no options set (use defaults)
$ swipl .\opts.pl
help(false)
noconnect(false)
server(www.google.com)
port(5000)

# setting various options
$ swipl .\opts.pl --server www.test.com -p 2342 -n
help(false)
server(www.test.com)
port(2342)
noconnect(true)

# show help
$ swipl .\opts.pl -h
Usage: swipl opts.pl <options>

--help       -h  boolean=false        Show Help
--noconnect  -n  boolean=false        do not connect, just check server status
--server     -s  atom=www.google.com  The server address.
--port       -p  integer=5000         The server port.
