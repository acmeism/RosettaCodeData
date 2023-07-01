val useOS =  fn input =>
  let
   val text       =   String.translate (fn #"\"" => "\\\""|n=>str n )  input ;
   val shellCommand = " echo " ^ text ^ "| gzip -c " ;
   val fname      =  "/tmp/fConv" ^ (String.extract (Time.toString (Posix.ProcEnv.time()),7,NONE) );
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
