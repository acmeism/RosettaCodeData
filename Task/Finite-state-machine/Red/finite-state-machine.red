Red [
	Title: "Finite State Machine"
	Author: "hinjolicious"
	Note: {Modelled after Prolog's mechecanism}
]

; FSM object

fsm: object [
	states: []
	messages: #[]
	current: none
	
	add: function [rule][append/only states rule]	;add rule
	
	show: function [/rule 'this][					;show a rule or all rules
		either rule [
			foreach r states [
				if r/1 = this [print mold r]
			]
		][print mold states]
	]
	
	set: func ['state][current: state]	; set current state
	get: func [] [current]				; get current state
	
	set-message: func ['state prompt][messages/:state: prompt]	; set a message for a state
	get-message: func ['state][messages/:state]					; get the message of a state
	show-messages: does [print mold messages]					; show all defined messages
	
	run: func [/from 'state][		; run the finite state manchine!
		if from [current: state]
		while [current <> 'exit][
			options: collect [foreach e states [if e/1 = current [keep/only next e]]]
			print get-message :current
			
			prin ["Option(s):"]
			repeat i length? options [prin rejoin [" " i ". " options/:i/1]] print ""
			if (empty? s: ask "Select: ") [return none]
			
			; process to the next transition
			cho: to-integer s
			current: options/:cho/2
			if none? current [current: options/:cho/1]
			print ""
		]
	]	
]

; Enter the rules

fsm/add [ready deposit waiting]
fsm/add [ready quit exit]

fsm/add [waiting select dispense]
fsm/add [waiting refund refunding]

fsm/add [dispense remove ready]
fsm/add [refunding ready]

; Add messages

fsm/set-message ready "Please deposit coins."
fsm/set-message waiting "Please select an item, or refund coins."
fsm/set-message dispense "Please remove your item."
fsm/set-message refunding "Coins have been refunded."

; Run from starting state!

fsm/run/from ready
print "Bye!"

