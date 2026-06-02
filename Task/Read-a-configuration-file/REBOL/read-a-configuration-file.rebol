Rebol [
    title: "Rosetta code: Read a configuration file"
    file:  %Read_a_configuration_file.r3
    url:   https://rosettacode.org/wiki/Read_a_configuration_file
]

parse-config: function/with [
    config [string! file! url!]
][
    config: either string? config [
        split-lines config
    ][  read/lines config ]
    out: #[]
    foreach line config [
        parse line [
              #"#" to end
            | any SP end
            | #";" option-rule to end (out/:option: false)
            | value-rule (
                foreach val value: split value #"," [
                    trim/head/tail val
                ]
                out/:option: case [
                    empty?  value [true]
                    single? value [first value]
                    'else         [value]
                ]
            )
        ]
    ]
    out
][
    option: value: _
    option-rule: [any SP copy option to [SP | #"=" | end] (try [option: to word! option])]
    value-rule:  [option-rule any SP opt #"=" any SP copy value to end]
]

probe parse-config {
# This is a configuration file in standard configuration file format
#
# Lines beginning with a hash or a semicolon are ignored by the application
# program. Blank lines are also ignored by the application program.

# This is the fullname parameter
FULLNAME Foo Barber

# This is a favourite fruit
FAVOURITEFRUIT banana

# This is a boolean that should be set
NEEDSPEELING

# This boolean is commented out
; SEEDSREMOVED

# Configuration option names are not case sensitive, but configuration parameter
# data is case sensitive and may be preserved by the application program.

# An optional equals sign can be used to separate configuration parameter data
# from the option name. This is dropped by the parser.

# A configuration option may take multiple parameters separated by commas.
# Leading and trailing whitespace around parameter names and parameter data fields
# are ignored by the application program.

OTHERFAMILY Rhu Barber, Harry Barber
}
