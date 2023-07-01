open List;

fun Ludi [] = []
 |  Ludi (T as h::L) =
    let
     fun next (h:: L ) =
       let
        val nw  =  #2 (ListPair.unzip (filter (fn (a,b) => a mod #2 h <> 0) L) )
        in
        ListPair.zip ( List.tabulate(List.length nw,fn i=>i) ,nw)
        end
     in
      h :: Ludi ( next T)
 end;

val ludics = 1:: (#2 (ListPair.unzip(Ludi (ListPair.zip ( List.tabulate(25000,fn i=>i),tabulate (25000,fn i=>i+2)) )) ));

app ((fn e => print (e^" ")) o Int.toString ) (take (ludics,25));
length (filter (fn e=> e <= 1000) ludics);
drop (take (ludics,2005),1999);
