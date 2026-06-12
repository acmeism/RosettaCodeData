require'strings'

'RULE_NAMES    RULES'=: |:':'&cut;._2 noun define
 	Printer does not print:              	Y   Y   Y   Y   N   N   N   N
 	A red light is flashing:             	Y   Y   N   N   Y   Y   N   N
 	Printer is unrecognised:             	Y   N   Y   N   Y   N   Y   N
)

'ACTION_NAMES  ACTIONS'=: |:':'&cut;._2 noun define
 	Check the power cable:               	-   -   X   -   -   -   -   -
 	Check the printer-computer cable:    	X   -   X   -   -   -   -   -
 	Ensure printer software is installed:	X   -   X   -   X   -   X   -
 	Check/replace ink:                   	X   X   -   -   X   X   -   -
 	Check for paper jam:                 	-   X   -   X   -   -   -   -
)

assert (-:~.)|: 'Y' =/&;: RULES
RULE_TABLE=: (,/'X'=/&;: ACTIONS) /:&|: 'Y' =/&;: RULES

troubleshoot =:  verb define
   RULE_TABLE troubleshoot~ RULE_NAMES ,&< ACTION_NAMES
:
   'q a'=.x
   smoutput 'Having trouble?  Let''s track down the problem:'
   options=. a #~ y {~ #. 'Y'={.@toupper@deb@(1!:1)@1:@smoutput@,&'?'@dtb"1 q
   (,~ ('/'cut'Suggested resolutions:/Solution unknown.') {::~ 0=#) options
)
