set fsm [dict create \
			 ready     {deposit waiting quit exit} \
			 waiting   {select dispense refund refunding} \
			 dispense  {remove ready} \
			 refunding {{} ready} \
			]
set state ready

proc prompt {fsm state} {
	set choices [dict keys [dict get $fsm $state]]
	while {1} {
		puts -nonewline "state: $state, possible actions: $choices\n>"
		if {[gets stdin line] == -1} {
			exit
		}
		if {$line in $choices} {
			return $line
		}
	}
}

while {$state ne "exit"} {
	set action [prompt $fsm $state]
	set state [dict get $fsm $state $action]
	while {[dict exists $fsm $state {}]} {
		set state [dict get $fsm $state {}]
	}
}
