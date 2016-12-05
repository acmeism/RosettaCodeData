loop(10) => {^
	loop_count
	loop_count % 5 ? ', ' | '\r'
	loop_count < 100 ? loop_continue
	'Hello, World!' // never gets executed
^}
