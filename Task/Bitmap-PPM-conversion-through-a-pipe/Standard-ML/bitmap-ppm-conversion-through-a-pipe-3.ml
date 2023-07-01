val demo = fn () =>
let
 val useOSConvert =  fn ppmf =>
  let
   val appopt     =   ("/usr/local/bin/convert",  ["convert","-",  "/tmp/out.jpeg"])
   val p          =   Posix.IO.pipe () ;
   val me         =   Posix.Process.fork ()
  in
   case  me of SOME cpd  =>
     (   Posix.IO.close (#outfd p);
	 Posix.IO.dup2 {old=(#infd p), new= Posix.FileSys.stdin } ;
	 Posix.IO.close (#infd p);
         Posix.Process.exec appopt
	)
     |   _   =>
     (   Posix.IO.close (#infd p);
         ppmf (#outfd p) ;
         Posix.IO.close (#outfd p) ;
	 OS.Process.exit OS.Process.success
     )
  end;

 fun output_ppm fd =                                                  (* placeholder for the ppm/bitmap functionality *)
      Posix.IO.writeVec ( fd ,
       Word8VectorSlice.full ( Byte.stringToBytes
       "P3 3 2 255 255   0   0    0 255   0   0   0 255  255 255   0 255 255 255   0   0   0 " )
      )

in

  useOSConvert output_ppm

end ;
