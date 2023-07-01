+++++ +++++	#0 set to n
>> +		Init #2 to 1
<<
[
	-	#Decrement counter in #0
	>>.	Notice: This doesn't print it in ascii
		To look at results you can pipe into a file and look with a hex editor
	
		Copying sequence to save #2 in #4 using #5 as restore space
	>>[-]	Move to #4 and clear
	>[-]	Clear #5
	<<<	#2
	[	Move loop
		- >> + > + <<<	Subtract #2 and add #4 and #5
	]
	>>>
	[	Restore loop
		- <<< + >>>	Subtract from #5 and add to #2
	]

	<<<<	Back to #1
		Non destructive add sequence using #3 as restore value
	[	Loop to add
		- > + > + <<	Subtract #1 and add to value #2 and restore space #3
	]
	>>
	[	Loop to restore #1 from #3
		- << + >>	Subtract from restore space #3 and add in #1
	]
	
	<< [-]	Clear #1
	>>>
	[	Loop to move #4 to #1
		- <<< + >>>	Subtract from #4 and add to #1
	]
	<<<<	Back to #0
]
