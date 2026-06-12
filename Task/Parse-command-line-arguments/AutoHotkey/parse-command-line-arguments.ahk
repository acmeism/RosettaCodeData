;Get Arguments as an array
if 0 > 0
{
	argc=%0%
	args:=[]
	Loop, %argc%
		args.Insert(%A_Index%)
}
else
{
	;if got no arguments, run self with arguments
	Run,%a_scriptFullpath% -i Lib\* -c files.c --verbose -o files.o --Optimze
	ExitApp
}

;Parse arguments
i:=0, msg:=""
while( i++ < argc ) {
	c:=SubStr(args[i],1,1)
	if c in -,/ ; List all switch chars
	{
		if ( SubStr(args[i],1,2) == "--" ) ; if "--" is used like "--verbose"
			msg:=msg args[i] "`t:`tTrue (Boolean)`n" ; parse as boolean
		else
			msg:=msg args[i] "`t:`t" args[++i] "`n"
	}
	else
		msg:=msg args[i] "`t:`t(normal)`n"
}

MsgBox % "Parsed Arguments :`n" msg
