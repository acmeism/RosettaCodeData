module Make =
  functor (M : sig val m : int val n : int end)
  -> struct

    let grid = Array.init M.m (fun _ -> Array.make M.n 0)

    let print () =
      for i = 0 to M.m - 1
      do for j = 0 to M.n - 1
         do Printf.printf "%d " grid.(i).(j)
         done
       ; print_newline ()
       done

    let unstable = Hashtbl.create 10

    let add_grain x y
      = grid.(x).(y) <- grid.(x).(y) + 1
      ; if grid.(x).(y) >= 4 then
          Hashtbl.replace unstable (x,y) () (* Use Hashtbl.replace for uniqueness *)

    let topple x y
      = grid.(x).(y) <- grid.(x).(y) - 4
      ; if grid.(x).(y) < 4
        then Hashtbl.remove unstable (x,y)
      ; match (x,y) with
        (* corners *)
        | (0,0) -> add_grain 1 0
                 ; add_grain 0 1
        | (0,n) when n = M.n - 1
          -> add_grain 1 n
           ; add_grain 0 (n-1)
        | (m,0) when m = M.m - 1
          -> add_grain m 1
           ; add_grain (m-1) 0
        | (m,n) when m = M.m - 1 && n = M.n - 1
          -> add_grain ( m ) (n-1)
           ; add_grain (m-1) ( n )
        (* sides *)
        | (0,y) -> add_grain 1 y
                 ; add_grain 0 (y+1)
                 ; add_grain 0 (y-1)
        | (m,y) when m = M.m - 1
          -> add_grain ( m ) (y-1)
           ; add_grain ( m ) (y+1)
           ; add_grain (m-1) ( y )
        | (x,0) -> add_grain (x+1) 0
                 ; add_grain (x-1) 0
                 ; add_grain ( x ) 1
        | (x,n) when n = M.n - 1
          -> add_grain (x-1) ( n )
           ; add_grain (x+1) ( n )
           ; add_grain ( x ) (n-1)
        (* else *)
        | (x,y) -> add_grain ( x ) (y+1)
                 ; add_grain ( x ) (y-1)
                 ; add_grain (x+1) ( y )
                 ; add_grain (x-1) ( y )

    let add_sand n x y
      = for i = 1 to n
        do add_grain x y
        done

    let avalanche ()
      = while Hashtbl.length unstable > 0
        do
         let unstable' = Hashtbl.fold  (fun (x,y) () r -> (x,y) :: r) unstable []
         in List.iter (fun (x,y) -> topple x y ) unstable'
        done
  end

(* testing *)

let ()
  = let module S = Make (struct let m = 11 let n = 11 end)
    in S.add_sand 500 5 5
     ; S.avalanche ()
     ; S.print ()
