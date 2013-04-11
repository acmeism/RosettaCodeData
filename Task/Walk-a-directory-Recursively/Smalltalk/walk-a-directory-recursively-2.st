|d|
d := Directory name: '.'.
d wholeContent: '\.st$' do: [ :f :l |
   0 to: l do: [ :i | (Character tab) display ].
   f displayNl
].
