let val out = TextIO.openOut "output.txt" in
  TextIO.closeOut out
end;

OS.FileSys.mkDir "docs";
