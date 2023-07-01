val Validate = fn jsonstring =>
let
 val Valid =  fn jsonstring =>
  let
   val json       =  String.translate (fn #"\"" => "\\\""|n=>str n ) jsonstring ;
   val textlength = (String.size json ) + 50 ;
   val app        = " jq -c '.' "
   val fname      = "/tmp/jsonval" ^ (String.extract (Time.toString (Posix.ProcEnv.time()),7,NONE) );
   val shellCommand = "echo  \"" ^ json ^ "\" | " ^ app
   val me         = (  Posix.FileSys.mkfifo (fname, Posix.FileSys.S.flags [ Posix.FileSys.S.irusr,Posix.FileSys.S.iwusr ] ) ;
                       Posix.Process.fork () ) ;
  in
   if (Option.isSome me) then
     let
        val fin =TextIO.openIn fname
     in
        ( Posix.Process.sleep (Time.fromReal 0.1) ;
          TextIO.inputN (fin,textlength) before
	  (TextIO.closeIn fin ; OS.FileSys.remove fname)
	)
     end
   else
     ( OS.Process.system ( shellCommand ^ " > " ^fname ^ " 2>&1 ") ;                                           (* remove fmt and validate *)
       "done\n" before OS.Process.exit OS.Process.success )
  end
 val result = Valid jsonstring
in
 if String.isPrefix "{" result then result else "JSON error\n"
end;



datatype ('a,'b) element = elem of 'a * 'b | markerb of int ;                       (*  <   internal structure   v   *)
datatype 'a content      = value of 'a | block of ('a,'a content) element list | arr of 'a content list |marker of int ;

exception Dtype of string ;
val unarr    =  fn arr lst => lst   |  _   =>  (raise Dtype "unarr"   ; []) ;
val unblock  =  fn block lst => lst |  _   =>  (raise Dtype "unblock" ; []) ;


(* --- example loop to apply a function 'dothis', which returns type jvals, to the structure  ---- *)

datatype jvals       = St of string | It of IntInf.int | Rl of real | Bl of bool ;        (* returned type by 'dothis' *)

val rec gothruAndDo = fn dothis => fn storedObject =>
   let
      val walk = fn elem ( n, value v)  => elem (dothis n , value (dothis v) )
                  | elem ( n, block v)  => elem (dothis n , block ( (gothruAndDo dothis)  (rev (tl (rev v)))) )
                  | elem ( n, arr v)    => elem (dothis n , arr ( List.map (block o (gothruAndDo dothis) o unblock)  (rev (tl (rev v))) ) )
		  | _                   => elem (St "", value (It (IntInf.fromInt ~1)))
   in
      List.map walk storedObject
 end;

(*  ------------------------------------  end of loop example  ------------------------------------ *)


local

exception Dtype of string ;
val markbToInt        =  fn markerb NrChars => NrChars | _  => (raise Dtype "markerb!" ; ~1) ;
val markToInt         =  fn  marker NrChars => NrChars |  _ => (raise Dtype "marker!"  ; ~1) ;


fun readarr rtag rc =  fn #"]"::S => [  marker (List.length S)   ]                                    (* process array *)
                        | S       => let val tmp = (rtag rc ("",S)) in  (block tmp)  ::
                                          ( readarr rtag rc (   List.drop (S,(List.length S) -   markbToInt ( hd (rev  tmp)))    ))  end ;



val rec readNaVa = fn rc : string * char list -> string content * char list   => fn
    ("",[])             => []
|   (sr,[])             =>   [ elem (sr, value "") ]
|   (sr,#":":: #"["::S) =>
                             let val tmp = arr (readarr readNaVa rc S) in                              (* field is array *)
                               ( elem (sr,  tmp )) :: (readNaVa rc ("" ,  List.drop (S,(List.length S) - (markToInt (hd (rev(unarr tmp)))) )     ))
			     end
|  (sr, #":":: #"{"::S) =>
                             let  val tmp = readNaVa rc ("",S )  in                                    (* field is object *)
                               ( elem (sr, block tmp)) :: (readNaVa rc ("" , List.drop (S,(List.length S) -(markbToInt ( hd (rev tmp))))    ))
                              end
|  (sr,#"}":: #","::S)  =>   [ markerb (List.length S) ]
|  (sr,#"}"::S)         =>   [ markerb (List.length S) ]
|  (sr,#":"::S)         =>
                             let val tmp = rc ("",S)  in                                                (* field is basic *)
                                elem ( sr, #1 tmp) :: (readNaVa rc ("",  #2  tmp ) )
                             end
|  (sr,#","::S)         =>   readNaVa rc (sr , S)
|  (sr,#"{"::a::S)      =>   readNaVa rc (sr^(str a) , S)
|  (sr,a::S)            =>   readNaVa rc (sr^(str a) , S)  ;                                            (* name field *)

 val rec readcontent = fn
   (sc,a::[])       => (value ( sc^(str a) ),[])
|  (sc,#","::t)     => (value  sc , t)
|  (sc, #"}"::t)    => (value  sc , #"}"::t)
|  (sc, #"]"::t)    => (value  sc , #"]"::t)
|  (sc, a::t)       => readcontent( ( sc^(str a) ),t) ;


val putall = fn input =>
 let
  val rec put  = fn
          []      => ""
    | (elem h)::t => (#1 h) ^ ":" ^ ( ( fn value x=> x
                                       | block x => "{" ^ (put x )
				       | arr x   => "["  ^  String.concat (( List.map (fn x=> "{"^( (put o unblock) x)^"," ) (rev (tl (rev x)))))  ^ "]" ) (#2 h))
					 ^ ","
					 ^ (put t)
    | (markerb h)::t => "}"
 in
   "{" ^ (put input)
 end;

val commas = fn tok => fn S =>
   ( Substring.concatWith (str tok)
     ( List.map (Substring.dropr (fn x=> x= #"," ))
          (Substring.tokens (fn x=> x= tok ) (Substring.full S) )) ) ^ (if tok = #"}" then str tok else "" )


in

  val storeJsString = fn input =>
      readNaVa readcontent ("" , String.explode (  Validate input ) )

  val writeJS = fn storedStruct =>
      ( ( ( commas #"}" ) o ( commas #"]" ) o putall ) storedStruct )

end ;
