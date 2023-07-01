//The type of the function argument determines whether or not the value is passed by reference or not.
//Eg. numbers are passed by value and lists/arrays are passed by reference.

software {
	print() 					//Calling a function with no arguments.
	print("Input a number!")	//Calling a function with fixed arguments.
	print(1,2,3,4,5,6,7,8,9,0) 	//Calling a function with variable arguments.
	input = read() 				//Obtaining the return value of a function.
	myprint = print
	myprint("It was: ", input)	//Calling first class functions, the same as calling ordinary functions.
	
	//The only distinction that can be made between two functions is if they are 'real' or not.
	if type(myprint) = concept
		print("myprint is a not a real function")
	else if type(myprint) = function
		print("myprint is a real function")
	end

	//Partial functions can be created with static parts.
	DebugPrint = print["[DEBUG] ", text]
	DebugPrint("partial function!")		//This would output '[DEBUG] partial function!'

	if type(DebugPrint) = concept
		print("DebugPrint is a not a real function")
	else if type(DebugPrint) = function
		print("DebugPrint is a real function")
	end
}
