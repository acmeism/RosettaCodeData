@include "readfile"
BEGIN {
    while(++i < ARGC)
        print gensub("Goodbye London!","Hello New York!","g", readfile(ARGV[i])) > ARGV[i]
}
