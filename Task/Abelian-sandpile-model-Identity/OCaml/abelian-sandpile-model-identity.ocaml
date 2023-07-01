(* https://en.wikipedia.org/wiki/Abelian_sandpile_model *)

module Make =
  functor (M : sig val m : int val n : int end)
  -> struct

    type t = { grid : int array array ; unstable : ((int*int),unit) Hashtbl.t }

    let make () = { grid = Array.init M.m (fun _ -> Array.make M.n 0); unstable = Hashtbl.create 10 }

    let print {grid=grid} =
      for i = 0 to M.m - 1
      do for j = 0 to M.n - 1
         do Printf.printf "%d " grid.(i).(j)
         done
       ; print_newline ()
       done

    let add_grain {grid=grid;unstable=unstable} x y
      = grid.(x).(y) <- grid.(x).(y) + 1
      ; if grid.(x).(y) >= 4 then
          Hashtbl.replace unstable (x,y) () (* Use Hashtbl.replace for uniqueness *)

    let topple ({grid=grid;unstable=unstable} as s) x y
      = grid.(x).(y) <- grid.(x).(y) - 4
      ; if grid.(x).(y) < 4
        then Hashtbl.remove unstable (x,y)
      ; let add_grain = add_grain s in match (x,y) with
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

    let add_sand s n x y
      = for i = 1 to n
        do add_grain s x y
        done

    let avalanche ?(avalanche_print=fun _ -> ()) ({grid=grid;unstable=unstable} as s)
      = while Hashtbl.length unstable > 0
        do
         let unstable' = Hashtbl.fold  (fun (x,y) () r -> (x,y) :: r) unstable []
         in List.iter (fun (x,y) -> topple s x y; avalanche_print s ) unstable'
        done

    let init ?(avalanche_print=fun _ -> ()) f
      = let s = { grid = Array.init M.m (fun x -> Array.init M.n (fun y -> f x y)) ; unstable = Hashtbl.create 10 }
        in Array.iteri (fun x -> Array.iteri (fun y e -> if e >= 4 then Hashtbl.replace s.unstable (x,y) ())) s.grid
         ; avalanche_print s
         ; avalanche ~avalanche_print s
         ; s

    let sandpile n
      = let s = make ()
        in add_sand s n (M.m/2) (M.n/2)
         ; avalanche s
         ; s

    let (+.) {grid=a} {grid=b}
      = let c = init (fun x y -> a.(x).(y) + b.(x).(y))
        in avalanche c
         ; c
  end

(* testing *)

let ()
  = let module S = Make (struct let m = 3 let n = 3 end)
    in let open S
       in print_endline "Avalanche example"
        ; begin
           let s0 = init ~avalanche_print:(fun s -> print s
                                                  ; print_endline "  ↓")
                      (fun x y -> [| [| 4 ; 3 ; 3 |]
                                   ; [| 3 ; 1 ; 2 |]
                                   ; [| 0 ; 2 ; 3 |]
                                  |].(x).(y))
           in print s0
            ; print_endline "---------------"
         end
        ; print_endline "Addition example"
        ; begin
            let  s1 = init (fun x y -> [| [| 1 ; 2 ; 0 |]
                                        ; [| 2 ; 1 ; 1 |]
                                        ; [| 0 ; 1 ; 3 |]
                                       |].(x).(y))
             and s2 = init (fun x y -> [| [| 2 ; 1 ; 3 |]
                                        ; [| 1 ; 0 ; 1 |]
                                        ; [| 0 ; 1 ; 0|]
                                       |].(x).(y))
             and s3 = init (fun _ _ -> 3)
             and s3_id = init (fun x y -> match (x,y) with
                                          | ((0,0)|(2,0)|(0,2)|(2,2)) -> 2
                                          | ((1,0)|(1,2)|(0,1)|(2,1)) -> 1
                                          | _ -> 0)
            in print s1
             ; print_endline "  +"
             ; print s2
             ; print_endline "  ="
             ; print (s1 +. s2)
             ; print_endline "------ Identity examples -----"
             ; print s3
             ; print_endline "  +"
             ; print s3_id
             ; print_endline "  ="
             ; print (s3 +. s3_id)
             ; print_endline "-----"
             ; print s3_id
             ; print_endline "  +"
             ; print s3_id
             ; print_endline "  ="
             ; print (s3_id +. s3_id)
          end
