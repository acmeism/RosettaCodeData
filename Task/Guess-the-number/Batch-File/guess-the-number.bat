@ECHO OFF
setlocal EnableDelayedExpansion
SET max=10
SET min=1

:begin
	SET /A rand=%random% %% (max - min + 1)+ min
	SET guess=
	SET /P guess=Pick a number between 1 and 10:

:loop
	IF "!guess!" == "" (
		GOTO end
	)
	SET /A guess=!guess!
	IF !guess! equ !rand! (
		ECHO Well guessed^^!
		GOTO end
	)
	SET guess=
	SET /P guess=Nope, guess again:
	GOTO loop

:end

ENDLOCAL
