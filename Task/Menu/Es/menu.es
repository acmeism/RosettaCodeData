# choose 'choice 1' 'choice 2' ...
#   Prints menu to standard error. Prompts with $prompt.
#   Returns choice. If no input, returns empty list.
fn choose args {
	# If args are empty, return empty list.
	~ $#args 0 && return

	# Echo to standard error.
	let (reply =; choice =; fn-menu =; fn-ch =) >[1=2] {
		fn-menu = {
			# Show menu.
			let (i = 1) for (c = $args) {
				echo $i') '$c
				i = `{expr $i + 1}
			}
		}
		fn-ch = {
			# Set choice = $args($reply), but ignore error
			# if $reply is not a valid index.
			choice = <={catch @ e {result} {
				result $args($reply)
			}}
		}

		menu
		forever {
			# Show prompt, read reply.
			echo -n $prompt
			reply = <={%read}

			# If no input, return empty list.
			~ $#reply 0 && return

			# Parse reply and return choice.
			reply = <={%split \ \t\n $reply}
			if {~ $#reply 0} {
				# Empty reply: show menu again.
				menu
			} {~ $#reply 1 && ch; ~ $#choice 1} {
				return $choice
			} {
				echo Invalid choice.
			}
		}
	}
}

let (choice = <={
	local (prompt = 'Which is from the three pigs: ')
		choose 'fee fie' 'huff and puff' 'mirror mirror' 'tick tock'
}) {
	~ $#choice 1 && echo You chose: $choice
	~ $#choice 0 && echo No input.
}
