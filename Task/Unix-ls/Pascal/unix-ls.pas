Program ls;	{To list the names of all files/directories in the current directory.}
 Uses DOS;
 var DirInfo: SearchRec;	{Predefined. See page 403 of the Turbo Pascal 4 manual.}
 BEGIN
  FindFirst('*.*',AnyFile,DirInfo);	{AnyFile means any file name OR directory name.}
  While DOSerror = 0 do			{Result of FindFirst/Next not being a function, damnit.}
   begin
    WriteLn(DirInfo.Name);
    FindNext(DirInfo);
   end;
 END.
