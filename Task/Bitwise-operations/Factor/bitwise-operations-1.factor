"a=" "b=" [ write readln string>number ] bi@
{
    [ bitand "a AND b: " write . ]
    [ bitor "a OR b: " write . ]
    [ bitxor "a XOR b: " write . ]
    [ drop bitnot "NOT a: " write . ]
    [ abs shift "a asl b: " write . ]
    [ neg shift "a asr b: " write . ]
} 2cleave
