structure TTd  =  Thread.Thread ;
structure TTm  =  Thread.Mutex  ;

val threadedStringList =  fn tasks:string list  =>
 let
  val mx        =  TTm.mutex () ;
  val taskstore =  ref tasks ;
  fun makeFastRand () =  Real.rem (Time.toReal (Time.now ()),1.0)
  val doTask =  fn () =>
   let
    val mytask :  string  ref   = ref "" ;
   in
   (   TTm.lock mx ; mytask :=  hd ( !taskstore ) ;  taskstore:= tl (!taskstore) ; TTm.unlock mx ;
       Posix.Process.sleep (Time.fromReal (makeFastRand ())) ;
       TTm.lock mx ; print ( !mytask ^ "\n")  ;   TTm.unlock mx ;
       TTd.exit ()
   )
   end
in

 List.tabulate ( length tasks , fn i => TTd.fork (doTask , []) )

end ;
