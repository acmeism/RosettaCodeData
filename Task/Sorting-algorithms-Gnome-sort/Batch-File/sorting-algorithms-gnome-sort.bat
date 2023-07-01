@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
:: GnomeSort.cmd in WinNT Batch using pseudo array.
:: Set the number of random elements to sort.
SET numElements=100
:: Decrement numElements for use in zero-based loops as in (0, 1, %numElements% - 1).
SET /A tmpElements=%numElements% - 1

:: Create array of random numbers and output to file.
ECHO GnomeSort Random Input 0 to %tmpElements%:>%~n0.txt
FOR /L %%X IN (0, 1, %tmpElements%) DO (
	SET array[%%X]=!RANDOM!
	ECHO !array[%%X]!>>%~n0.txt
)

:GnomeSort
:: Initialize the pointers i-1, i, and j.
SET gs1=0
SET gs2=1
SET gs3=2
:GS_Loop
:: Implementing a WHILE loop in WinNT batch using GOTO. It only executes
:: if the condition is true and continues until the condition is false.
:: First, display [i-1][j - 2] to the Title Bar.
SET /A gsTmp=%gs3% - 2
TITLE GnomeSort:[%gs1%][%gsTmp%] of %tmpElements%
:: ...then start Main Loop. It's a direct implementation of the
:: pseudo code supplied by Rosetta Code. I had to add an additional
:: pointer to represent i-1, because of limitations in WinNT Batch.
IF %gs2% LSS %numElements% (
	REM if i-1 <= i advance pointers to next unchecked element, then loop.
	IF !array[%gs1%]! LEQ !array[%gs2%]! (
		SET /A gs1=%gs3% - 1
		SET /A gs2=%gs3%
		SET /A gs3=%gs3% + 1
	) ELSE (
	REM ... else swap i-1 and i, decrement pointers to check previous element, then loop.
		SET gsTmp=!array[%gs1%]!
		SET array[%gs1%]=!array[%gs2%]!
		SET array[%gs2%]=!gsTmp!
		SET /A gs1-=1
		SET /A gs2-=1
		REM if first element has been reached, set pointers to next unchecked element.
		IF !gs2! EQU 0 (
			SET /A gs1=%gs3% - 1
			SET /A gs2=%gs3%
			SET /A gs3=%gs3% + 1
		)
	)
	GOTO :GS_Loop
)
TITLE GnomeSort:[%gs1%][%gsTmp%] - Done!

:: write sorted elements out to file
ECHO.>>%~n0.txt
ECHO GnomeSort Sorted Output 0 to %tmpElements%:>>%~n0.txt
FOR /L %%X IN (0, 1, %tmpElements%) DO ECHO !array[%%X]!>>%~n0.txt

ENDLOCAL
EXIT /B 0
