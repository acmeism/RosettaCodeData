((main
    {"The quick brown fox jumps over the lazy dog.\n"
    dup <<

    17 caesar_enc !
    dup <<

    17 caesar_dec !
    <<})

(caesar_enc
        { 2 take
        { caesar_enc_loop ! }
    nest })

(caesar_enc_loop {
    give
    <- str2ar
        {({ dup is_upper ! }
                { 0x40 -
                -> dup <-
                encrypt !
                0x40 + }
             { dup is_lower ! }
                { 0x60 -
                -> dup <-
                encrypt !
                0x60 + }
            { 1 }
                {fnord})
        cond}
    eachar
    collect !
    ls2lf ar2str})

(collect { -1 take })

(encrypt { + 1 - 26 % 1 + })

(caesar_dec { <- 26 -> - caesar_enc ! })

(is_upper
    { dup
    <- 0x40 cugt ->
    0x5b cult
    cand })

(is_lower
    { dup
    <- 0x60 cugt ->
    0x7b cult
    cand }))
