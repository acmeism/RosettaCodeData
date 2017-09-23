BEGIN {
	meaning = 6 * 7
	assert(meaning == 42, "Integer mathematics failed")
	assert(meaning == 42)
	meaning = strtonum("42 also known as forty-two")
	assert(meaning == 42, "Built-in function failed")
	meaning = "42"
	assert(meaning == 42, "Dynamic type conversion failed")
	meaning = 6 * 9
	assert(meaning == 42, "Ford Prefect's experiment failed")
	print "That's all folks"
	exit
}

# Errormsg is optional, displayed if assertion fails
function assert(cond, errormsg){
	if (!cond) {
		if (errormsg != "") print errormsg
		exit 1
	}
}
