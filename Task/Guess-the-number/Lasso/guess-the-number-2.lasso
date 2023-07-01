<?LassoScript

local(
	number	= integer(web_request -> param('number') or integer_random(10, 1)),
	status	= false,
	guess	= web_request -> param('guess'),
	_guess	= integer(#guess),
	message	= 'Guess a number between 1 and 10'
)



if(#guess) => {
	if(not (range(#_guess, 1, 10) == #_guess)) => {
		#Message = 'Input not of correct type or range. Guess a number between 1 and 10'
	else(#_guess == #number)
		#Message = 'Well guessed!'
		#status = true
	else
		#Message = 'You guessed wrong number. Guess a number between 1 and 10'
	}
}


?><!DOCTYPE html>
<html lang="en">
	<head>
		<title>Guess the number - Rosetta Code</title>
	</head>
	<body>
		<h3>[#message]</h3>
[if(not #status)]
		<form method="post">
			<label for="guess">Guess:</label><br/ >
			<input type="number" name="guess" />
			<input name="number" type="hidden" value="[#number]" />
			<input name="submit" type="submit" />
		</form>
[/if]
	</body>
</html>
