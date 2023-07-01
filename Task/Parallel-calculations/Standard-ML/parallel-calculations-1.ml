structure TTd  =  Thread.Thread ;
structure TTm  =  Thread.Mutex  ;


val threadedBigPrime =  fn input:IntInf.int list  =>

let

(* --------------------- code from prime decomposition page  ------------------- *)
  val factor = fn n :IntInf.int  =>
   let
     val unfactored  = fn (u,_,_)   => u; val factors = fn (_,f,_) => f; val try  = fn (_,_,i)   => i; fun getresult t = unfactored t::(factors t);
     fun until done change x = if done x  then getresult x else until done change (change x);       (* iteration *)
     fun lastprime t = unfactored t  <  (try t)*(try t)
     fun trymore t   = if unfactored t mod (try t) = 0  then (unfactored t div (try t) , try t::(factors t) , try t) else (unfactored t, factors t , try t + 1)
   in  until lastprime trymore (n,[],2)  end;
(* --------------------- end of code from prime decomposition page  ------------ *)


 val mx   =  TTm.mutex () ;
 val results :  IntInf.int list list ref  =  ref [  ] ;
 val tasks   :  IntInf.int list list ref  =  ref [  ] ;


 val divideup =  fn cores => fn inp : IntInf.int list =>
  let
   val np = (List.length inp) div cores + (cores +1) div cores                          (* assume length > cores to reduce code *)
   val rec divd = fn ([], outp)    =>  ([],outp )
                      | (inp,outp) =>  divd ( List.drop (inp,np) , (List.take (inp,np))::outp )  handle Subscript => ([],inp :: outp)
  in
    #2 ( divd (inp, [ ] ))
  end;


 val doTask =  fn () =>
  let
    val mytask :  IntInf.int list ref     = ref [];
    val myres  : IntInf.int list list ref = ref [];
  in
   (   TTm.lock mx ; mytask :=  hd ( !tasks ) ;  tasks:= tl (!tasks)   ; TTm.unlock mx ;
       myres  :=  List.map  factor ( !mytask ) ;
       TTm.lock mx ; results :=  !myres @ ( !results )   ; TTm.unlock mx ;
       TTd.exit ()
   )
 end;


 val cores     =  TTd.numProcessors ();
 val tmp       =  tasks :=  divideup cores input ;
 val processes =  List.tabulate ( cores , fn i => TTd.fork (doTask , []) ) ;
 val maxim     =  ( while ( List.exists TTd.isActive processes ) do (Posix.Process.sleep (Time.fromReal 1.0 ));
                    List.foldr IntInf.max  1 ( List.map (fn i => List.last i ) (!results) ) )                   (* maximal lowest prime *)

in

   List.filter (fn lst => List.last lst = maxim ) (!results)

end ;
