#(
  'The better the 4-wheel drive, the further you''ll be from help when ya get stuck!'
  'headmistressship'
  'aardvark'
  '😍😀🙌💃😍😍😍🙌'
) do:[:eachWord |
  |shortened|

  shortened :=
    String streamContents:[:out |
        eachWord inject:nil into:[:prev :this |
            prev ~= this ifTrue:[out nextPut:this].
            this
        ]
    ].
  Transcript
    showCR:( eachWord,'(length:',eachWord size,')' );
    showCR:( shortened,'(length:',shortened size,')' ).
]
