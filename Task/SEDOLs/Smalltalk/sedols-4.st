#(
    '710889'
    'B0YBKJ'
    '406566'
    'B0YBLH'
    '228276'
    'B0YBKL'
    '557910'
    'B0YBKR'
    '585284'
    'B0YBKT'
    'B00030'
) do:[:in |
    |um check|

    sum := 0.
    (in to:6) with:#[1 3 1 7 3 9 ] do:[:ch :weight |
        sum := sum + (ch digitValue * weight).
    ].
    check := (10 - (sum%10)) % 10.
    Transcript showCR: ( in,(Character digitValue:check))
].
