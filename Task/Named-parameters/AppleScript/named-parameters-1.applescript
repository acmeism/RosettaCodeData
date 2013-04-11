on getName(x)
	set {firstName, lastName} to {"?", "?"}
	try
		set firstName to x's firstName
	end try
	try
		set lastName to x's lastName
	end try
end getName
