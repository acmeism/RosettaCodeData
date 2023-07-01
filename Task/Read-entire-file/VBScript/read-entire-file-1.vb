dim s
s = createobject("scripting.filesystemobject").opentextfile("slurp.vbs",1).readall
wscript.echo s
