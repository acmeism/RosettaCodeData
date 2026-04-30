put system/catalog 'time-zones make map! [
    NST  -3:30 NDT  -2:30  AST  -4:00 ADT -3:00 EST -5:00 EDT -4:00
    CST  -6:00 CDT  -5:00  MST  -7:00 MDT -6:00 PST -8:00 PDT -7:00
    AKST -9:00 AKDT -8:00 HAST -10:00 HADT -9:00
]
to-date: function/with [
    "Converts to date! value."
    value [any-type!] "May be also a standard Internet date string/binary"
    /utc "Returns the date with UTC zone"
][
    if all [
        any [string? value binary? value]
        parse value [
            5 skip
             copy day:   1 2 numeric sp
             copy month:   3 alpha   sp
             copy year:  1 4 numeric sp
             copy time: to sp sp
            [copy zone: [plus-minus 4 numeric] | no-case "GMT" (zone: "+0")]
            to end ; ignore the rest (like comments in mime fields)!
            |
             copy day:   1 2 numeric #"-"
             copy month: 1 2 numeric #"-"
             copy year:  1 4 numeric sp
             copy time: [1 2 numeric #":" 1 2 numeric opt [#":" 1 2 numeric]]
             to end
            |
             copy month: some alpha sp
             copy day:  1 2 numeric sp
             copy year: 1 4 numeric sp
             copy time: [1 2 numeric #":" 1 2 numeric opt [#":" 1 2 numeric]]
             opt ["pm" (time: 12:00 + to time! time) | "am"] sp
             copy zone: 3 4 alpha (zone: select system/catalog/time-zones to word! zone)
        ]
    ][
        value: to string! rejoin [day "-" month "-" year "/" time any [zone ""]]
    ]
    if all [value: to date! value  utc] [ value/timezone: 0 ]
    value
] system/catalog/bitsets

probe 12:00 + to-date "March 7 2009 7:30pm EST"
probe 12:00 + to-date "Sat, 7 Mar 2009 19:30:00 -0500"
