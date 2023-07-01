val useOSConvert =  fn ppm =>
  let
   val img       =   String.translate (fn #"\"" => "\\\""|n=>str n )  ppm ;
   val app        = " convert  -  jpeg:- "
   val fname      = "/tmp/fConv" ^ (String.extract (Time.toString (Posix.ProcEnv.time()),7,NONE) );
   val shellCommand = " echo   \"" ^ img  ^ "\"  | "  ^  app  ;
   val me         = (  Posix.FileSys.mkfifo
                               (fname,
			        Posix.FileSys.S.flags [ Posix.FileSys.S.irusr,Posix.FileSys.S.iwusr ]
			       ) ;
                       Posix.Process.fork ()
		     ) ;
  in
   if (Option.isSome me) then
     let
        val fin =BinIO.openIn fname
     in
        ( Posix.Process.sleep (Time.fromReal 0.1) ;
          BinIO.inputAll fin  before
	  (BinIO.closeIn fin ; OS.FileSys.remove fname )
	)
     end
   else
     ( OS.Process.system (  shellCommand ^ " > " ^ fname  ^ " 2>&1 "     ) ;
       Word8Vector.fromList [] before OS.Process.exit OS.Process.success
     )
  end;
