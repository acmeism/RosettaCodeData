//'i' does not have goto statements, instead control flow is the only legal way to navigate the program.
concept there() {
	print("Hello there")
	return //The return statement goes back to where the function was called.
	print("Not here")
}

software {
	loop {
		break //This breaks the loop, the code after the loop block will be executed next.
		
		print("This will never print")
	}
	
	loop {
		loop {
			loop {
				break //This breaks out of 1 loop.
			}
			print("This will print")
			break 2 //This breaks out of 2 loops.
		}
		print("This will not print")
	}
	
	
	//Move to the code contained in the 'there' function.
	there()
}
