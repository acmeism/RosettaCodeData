local(f) = file('foo.txt')
handle => {#f->close}
#f->forEachLine => {^
    #1
    '<br>' // note this simply inserts an HTML line break between each line.
^}
