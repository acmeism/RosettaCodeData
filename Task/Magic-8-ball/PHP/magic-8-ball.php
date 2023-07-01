<?php

$fortunes = array(
	"It is certain",
	"It is decidedly so",
	"Without a doubt",
	"Yes, definitely",
	"You may rely on it",
	"As I see it, yes",
	"Most likely",
	"Outlook good",
	"Signs point to yes",
	"Yes",
	"Reply hazy, try again",
	"Ask again later",
	"Better not tell you now",
	"Cannot predict now",
	"Concentrate and ask again",
	"Don't bet on it",
	"My reply is no",
	"My sources say no",
	"Outlook not so good",
	"Very doubtful"
);

/*
 * Prompt the user at the CLI for the command
 */
function cli_prompt( $prompt='> ', $default=false ) {

	// keep asking until a non-empty response is given
	do {
		// display the prompt
		echo $prompt;

		// read input and remove CRLF
		$cmd = chop( fgets( STDIN ) );

	} while ( empty( $default ) and empty( $cmd ) );

	return $cmd ?: $default;

}

$question = cli_prompt( 'What is your question? ' );

echo 'Q: ', $question, PHP_EOL;

echo 'A: ', $fortunes[ array_rand( $fortunes ) ], PHP_EOL;
