USING: command-line formatting grouping io kernel math.parser
namespaces prettyprint sequences splitting ;
IN: rosetta-code.canonicalize-cidr

! canonicalize a CIDR block: make sure none of the host bits are set
command-line get [ lines ] when-empty
[
    ! ( CIDR-IP -- bits-in-network-part dotted-decimal )
    "/" split first2 string>number swap

    ! get IP as binary string
    "." split [ string>number "%08b" sprintf ] map "" join

    ! replace the host part with all zeros
    over cut length [ CHAR: 0 ] "" replicate-as append

    ! convert back to dotted-decimal
    8 group [ bin> number>string ] map "." join swap

    ! and output
    "%s/%d\n" printf
] each
