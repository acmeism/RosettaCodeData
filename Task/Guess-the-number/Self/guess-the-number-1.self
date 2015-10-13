(|
parent* = traits clonable.
copy = (resend.copy secretNumber: random integerBetween: 1 And: 10).
secretNumber.

ask             = ((userQuery askString: 'Guess the Number: ') asInteger).
reportSuccess   = (userQuery report: 'You got it!').
reportFailure   = (userQuery report: 'Nope. Guess again.').
sayIntroduction = (userQuery report: 'Try to guess my secret number between 1 and 10.').

hasGuessed = ( [ask = secretNumber] onReturn: [|:r| r ifTrue: [reportSuccess] False: [reportFailure]] ).
run  = (sayIntroduction. [hasGuessed] whileFalse)
|) copy run
