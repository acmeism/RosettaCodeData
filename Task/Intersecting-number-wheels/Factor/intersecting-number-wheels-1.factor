USING: accessors assocs circular io kernel lists lists.lazy math
math.parser multiline peg.ebnf prettyprint prettyprint.custom
sequences strings ;
IN: rosetta-code.number-wheels

TUPLE: group pretty list ;

C: <group> group

M: group pprint* pretty>> write ;

TUPLE: number-wheel seq i ;

: <number-wheel> ( seq -- number-wheel )
    <circular> 0 number-wheel boa ;

: yield ( assoc -- n )
    dup first first [ dup integer? ]
    [ dupd of [ i>> ] [ [ 1 + ] change-i seq>> nth ] bi ] until
    nip ;

: number-wheel>lazy ( assoc -- list )
    0 lfrom swap [ yield nip ] curry lmap-lazy ;

EBNF: nw-parser [=[
    num   = [0-9]+ => [[ >string string>number ]]
    name  = [a-zA-Z]+ => [[ >string ]]
    wheel = (" "~ (num | name))+ "\n"?
          => [[ but-last first <number-wheel> ]]
    group = (name ":"~ wheel)+ => [[ number-wheel>lazy ]]
]=]

SYNTAX: NUMBER-WHEELS: parse-here dup nw-parser <group> suffix! ;

: .take ( n group -- )
    list>> ltake list>array [ pprint bl ] each "..." print ;
