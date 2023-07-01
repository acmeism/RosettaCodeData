val getTime =  fn url =>
  let
   val fname       = "/tmp/fConv" ^ (String.extract (Time.toString (Posix.ProcEnv.time()),7,NONE) );
   val shellCommand = " fetch -o - \""^ url ^"\" | sed -ne 's/^.*alt=.Los Angeles:\\(.* (Daylight Saving)\\).*$/\\1/p' " ;
    val me         = (  Posix.FileSys.mkfifo
                               (fname,
			        Posix.FileSys.S.flags [ Posix.FileSys.S.irusr,Posix.FileSys.S.iwusr ]
			       ) ;
                       Posix.Process.fork ()
		     )
  in
   if (Option.isSome me) then
     let
        val fin =TextIO.openIn fname
     in
        ( Posix.Process.sleep (Time.fromReal 0.5) ;
          TextIO.inputLine fin  before
	  (TextIO.closeIn fin ; OS.FileSys.remove fname )
	)
     end
   else
     ( OS.Process.system (  shellCommand ^ " > " ^ fname  ^ " 2>&1 "     ) ;
      SOME "" before OS.Process.exit OS.Process.success
     )
end;

print ( valOf (getTime "http://www.time.org"));
