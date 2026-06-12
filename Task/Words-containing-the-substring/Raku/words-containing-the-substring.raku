put 'unixdict.txt'.IO.words».fc.grep({ (.chars > 11) && (.contains: 'the') })\
    .&{"{+$_} words:\n  " ~ .batch(8)».fmt('%-17s').join: "\n  "};
