NB. no trailing linefeed
A=: '1 2 3'

NB. removing linefeed
A=: 0 : 0-.LF
1 2 3
)

NB. removing linefeed
A=: {{)n
1 2 3
}}-.LF
