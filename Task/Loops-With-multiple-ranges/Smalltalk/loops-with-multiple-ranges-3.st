...
{
    (three negated to: 3**3  by: three       ) .
    (seven negated to: seven by: x           ) .
    (555           to: 550-y                 ) .
    (22            to: -28  by: three negated) .
    (1927          to: 1939                  ) .
    (x             to: y    by:z             ) .
    (11**x         to: 11**x + one           ) .
} do:[:eachRange |
    eachRange
        select:[:j | ((prod abs < (2**27)) and:[ j ~= 0 ]) ]
        thenDo:[:j | prod := prod*j ].
    ]
].
...
