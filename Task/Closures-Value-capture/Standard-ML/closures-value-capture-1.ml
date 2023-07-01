List.map (fn x => x () )  ( List.tabulate (10,(fn i => (fn  ()=> i*i)) ) ) ;
