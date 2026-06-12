string targetfile = "pycon-china";
targetfile = System.resolvepath(targetfile);
mv(targetfile, targetfile+"~");
Stdio.write_file(targetfile, "this task was solved at the pycon china 2011");
