USING: formatting kernel lists lists.lazy math math.parser
sequences ;

1 lfrom [ >bin dup append bin> ] lmap-lazy [ 1000 < ] lwhile
[ dup "%d %b\n" printf ] leach
