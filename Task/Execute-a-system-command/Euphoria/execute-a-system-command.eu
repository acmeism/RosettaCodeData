 -- system --
-- the simplest way --
-- system spawns a new shell so I/O redirection is possible --

system( "dir /w c:\temp\ " ) -- Microsoft --

system( "/bin/ls -l /tmp" ) -- Linux BSD OSX --

----

 -- system_exec() --
 -- system_exec does not spawn a new shell --
 -- ( like bash or cmd.exe ) --

integer exit_code = 0
sequence ls_command = ""

ifdef UNIX or LINUX or OSX then
    ls_command = "/bin/ls -l "
elsifdef WINDOWS then
    ls_command = "dir /w "
end ifdef

exit_code = system_exec( ls_command )

if exit_code = -1 then
    puts( STDERR, " could not execute " & ls_command & "\n" )
elsif exit_code = 0 then
    puts( STDERR, ls_command & " succeeded\n")
else
    printf( STDERR, "command %s failed with code %d\n", ls_command, exit_code)
end if
