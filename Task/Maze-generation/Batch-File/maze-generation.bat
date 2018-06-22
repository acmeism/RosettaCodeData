:amaze Rows Cols [wall char]
:: A stack-less, iterative, depth-first maze generator in native WinNT batch.
:: Rows and Cols must each be >1 and Rows*Cols cannot exceed 2096.
:: Default wall character is #, [wall char] is used if provided.

@ECHO OFF
SETLOCAL EnableDelayedExpansion

:: check for valid input, else GOTO :help
IF /I "%~2" EQU "" GOTO :amaze_help
FOR /F "tokens=* delims=0123456789" %%A IN ("%~1%~2") DO IF "%%~A" NEQ "" GOTO :amaze_help
SET /A "rows=%~1, cols=%~2, mTmp=rows*cols"
IF !rows! LSS 2    GOTO :amaze_help
IF !cols! LSS 2    GOTO :amaze_help
IF !mTmp! GTR 2096 GOTO :amaze_help

:: set map characters and use 1st character of %3 for wall, if defined
SET "wall=#"
SET "hall= "
SET "crumb=."
IF "%~3" NEQ "" SET "wall=%~3"
SET "wall=!wall:~0,1!"

:: assign width, height, cursor position, loop count, and offsets for NSEW
SET /A "cnt=0, wide=cols*2-1, high=rows*2-1, size=wide*high, N=wide*-2, S=wide*2, E=2, W=-2"

:: different random entrance points
:: ...on top
:: SET /A "start=(!RANDOM! %% cols)*2"
:: ...on bottom
:: SET /A "start=size-(!RANDOM! %% cols)*2-1"
:: ...on top or bottom
:: SET /A ch=cols*2, ch=!RANDOM! %% ch
:: IF !ch! GEQ !cols! ( SET /A "start=size-(ch-cols)*2-1"
:: ) ELSE SET /A start=ch*2
:: random entrance inside maze
SET /A "start=(!RANDOM! %% cols*2)+(!RANDOM! %% rows*2)*wide"
SET /A "curPos=start, cTmp=curPos+1, loops=cols*rows*2+1"

:: fill the maze with 8186 wall characters, clip to size, and open 1st cell
SET "mz=!wall!"
FOR /L %%A IN (1,1,6) DO SET mz=!mz!!mz!!mz!!mz!
SET bdr=!mz:~-%wide%!
SET mz=!mz:~3!!mz:~3!
SET mz=!mz:~-%size%!
SET mz=!mz:~0,%curPos%!!hall!!mz:~%cTmp%!

:: iterate #cells*2+1 steps of random depth-first search
FOR /L %%@ IN (1,1,%loops%) DO (
	SET "rand=" & SET "crmPos="
	REM set values for NSEW cell and wall positions
	SET /A "rCnt=rTmp=0, cTmp=curPos+1, np=curPos+N, sp=curPos+S, ep=curPos+E, wp=curPos+W, wChk=curPos/wide*wide, eChk=wChk+wide, nw=curPos-wide, sw=curPos+wide, ew=curPos+1, ww=curPos-1"
	REM examine adjacent cells, build direction list, and find last crumb position
	FOR /F "tokens=1-8" %%A IN ("!np! !sp! !ep! !wp! !nw! !sw! !ew! !ww!") DO (
		IF !np! GEQ 0 IF "!mz:~%%A,1!" EQU "!wall!" ( SET /A rCnt+=1 & SET "rand=n !rand!"
		) ELSE IF "!mz:~%%E,1!" EQU "!crumb!" SET /A crmPos=np, cw=nw
		IF !sp! LEQ !size! IF "!mz:~%%B,1!" EQU "!wall!" ( SET /A rCnt+=1 & SET "rand=s !rand!"
		) ELSE IF "!mz:~%%F,1!" EQU "!crumb!" SET /A crmPos=sp, cw=sw
		IF !ep! LEQ !eChk! IF "!mz:~%%C,1!" EQU "!wall!" ( SET /A rCnt+=1 & SET "rand=e !rand!"
		) ELSE IF "!mz:~%%G,1!" EQU "!crumb!" SET /A crmPos=ep, cw=ew
		IF !wp! GEQ !wChk! IF "!mz:~%%D,1!" EQU "!wall!" ( SET /A rCnt+=1 & SET "rand=w !rand!"
		) ELSE IF "!mz:~%%H,1!" EQU "!crumb!" SET /A crmPos=wp, cw=ww
	)
	IF DEFINED rand ( REM adjacent unvisited cell is available
		SET /A rCnt=!RANDOM! %% rCnt
		FOR %%A IN (!rand!) DO ( REM pick random cell + wall
			IF !rTmp! EQU !rCnt! SET /A "curPos=!%%Ap!, cTmp=curPos+1, mw=!%%Aw!, mTmp=mw+1"
			SET /A rTmp+=1
		)
		REM write the 2 new characters into the maze
		FOR /F "tokens=1-4" %%A IN ("!mw! !mTmp! !curPos! !cTmp!") DO (
			SET "mz=!mz:~0,%%A!!crumb!!mz:~%%B!"
			SET "mz=!mz:~0,%%C!!hall!!mz:~%%D!"
		)
	) ELSE IF DEFINED crmPos ( REM follow the crumbs backward
		SET /A mTmp=cw+1
		REM erase the crumb character and set new cursor position
		FOR /F "tokens=1-2" %%A IN ("!cw! !mTmp!") DO SET "mz=!mz:~0,%%A!!hall!!mz:~%%B!"
		SET "curPos=!crmPos!"
	)
)
SET /A open=cols/2*2, mTmp=open+1
ECHO !wall!!bdr:~0,%open%!!hall!!bdr:~%mTmp%!!wall!
FOR /L %%A IN (0,!wide!,!size!) DO IF %%A LSS !size! ECHO !wall!!mz:~%%A,%wide%!!wall!
ECHO !wall!!bdr:~0,%open%!!hall!!bdr:~%mTmp%!!wall!
ENDLOCAL
EXIT /B 0

:amaze_help
ECHO Usage:   %~0 Rows Cols [wall char]
ECHO          Rows^>1, Cols^>1, and Rows*Cols^<=2096
ECHO Example: %~0 11 39 @
ENDLOCAL
EXIT /B 0
