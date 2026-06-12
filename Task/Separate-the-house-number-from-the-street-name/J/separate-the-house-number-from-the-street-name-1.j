special=: '4',.'012345'
digit=: '0123456789'

nope=: {{>./({.I.y=' '),1+I. special +./@:(E."1) y}}
here=: {{I.1,~y e.digit}}
din5008=: ({.;}.)~ here {.@#~ nope < here
