val smltime= fn input =>                                                      (* parse given format *)
let
 val mth::day::year::itime::t =  String.fields Char.isSpace input ;
 val tmp      =  String.fields (fn x=> x= #":") itime;
 val h        =  (valOf(Int.fromString (hd tmp) )) + (if  String.isSuffix "pm" (hd(tl tmp)) then 12 else 0 ) ;
 val ms       =  (String.extract (hd (tl tmp), 0 ,SOME 2))^":00" ;
 val mth      =  String.extract (mth,0,SOME 3)
in
                                                                              (* Sat is a dummy *)
  Date.fromString  ("Sat "^mth ^" " ^ (StringCvt.padLeft #"0" 2 day) ^ " "^(StringCvt.padLeft #"0" 2 (Int.toString h))^":" ^ ms^" "^ year )

end;


local
   val date2real =  Time.toReal o Date.toTime o valOf
   val onehour   =  date2real (  Date.fromString "Mon Jan 01 23:59:59 1973" ) - ( date2real (  Date.fromString "Mon Jan 01 22:59:59 1973" )) ;
in
   val hoursFrom = fn hours => fn from =>
      (Date.fromTimeLocal o Time.fromReal)( (  date2real from) +   hours *  onehour );
end;
