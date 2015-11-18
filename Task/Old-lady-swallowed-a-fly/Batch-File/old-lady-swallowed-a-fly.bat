@echo off
setlocal enabledelayedexpansion

	%== An "ugly" pseudo-array ===%
set pseudo=^
fly/@^
spider/That_wiggled_and_jiggled_and_tickled_inside_her,@^
bird/How_absurd,_to_swallow_a_bird,@^
cat/Imagine_that._She_swallowed_a_cat,@^
dog/What_a_hog_to_swallow_a_dog,@^
goat/She_just_opened_her_throat_and_swallowed_that_goat,@^
cow/I_don't_know_how_she_swallowed_that_cow,@^
horse/She's_dead_of_course...

	%== Counting and seperating... ===%
set str=!pseudo!
:count
if "!str!"=="" goto print_song
for /f "tokens=1,* delims=@" %%A in ("!str!") do (
	set /a cnt+=1
	for /f "tokens=1,2 delims=/" %%C in ("%%A") do (
		set animal!cnt!=%%C
		set comment!cnt!=%%D
	)
	set str=%%B
)
goto count

	%== Print the song ===%
:print_song
for /l %%i in (1,1,!cnt!) do (
	echo There was an old lady who swallowed a !animal%%i!.
	if not "!comment%%i!"=="" echo !comment%%i:_= !	
	if %%i equ !cnt! goto done

	for /l %%j in (%%i,-1,2) do (
		set/a prev=%%j-1
		call set prev_animal=%%animal!prev!%%
		echo She swallowed the !animal%%j! to catch the !prev_animal!.
	)
	echo I don't know why she swallowed the fly.
	echo Perhaps she'll die.
	echo.
)
:done
pause>nul&exit/b 0
