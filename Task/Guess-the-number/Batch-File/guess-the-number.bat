@echo off
setlocal EnableDelayedExpansion
:begin
	SET /A rand=%random% %% (10 - 1 + 1)+ 1
	SET guess=
	SET /P guess=Pick a number between 1 and 10:
:loop
	IF "!guess!" == "" (
		EXIT
	)
	SET /A guess=!guess!
	IF !guess! equ !rand! (
		ECHO Well guessed^^!
		EXIT
	)
	SET guess=
	SET /P guess=Nope, guess again:
	GOTO loop
