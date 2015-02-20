set lines {
    "---------- Ice and Fire ------------"
    ""
    "fire, in end will world the say Some"
    "ice. in say Some"
    "desire of tasted I've what From"
    "fire. favor who those with hold I"
    ""
    "... elided paragraph last ..."
    ""
    "Frost Robert -----------------------"
}
foreach line $lines {
    puts [join [lreverse [regexp -all -inline {\S+} $line]]]
    # This would also work for data this simple:
    ### puts [lreverse $line]
}
