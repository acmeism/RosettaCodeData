(*
I define a discriminated union to provide Nonogram Solver functionality.
Nigel Galloway May 28th., 2016
*)
type N =
  |X |B |V
  static member fn n i =
    let     fn n i = [for g = 0 to i-n do yield Array.init (n+g) (fun e -> if e >= g then X else B)]
    let rec fi n i = [
      match n with
      | h::t -> match t with
                | [] -> for g in fn h i do yield Array.append g (Array.init (i-g.Length) (fun _ -> B))
                | _  -> for g in fn h ((i-List.sum t)+t.Length) do for a in fi t (i-g.Length-1) do yield Array.concat[g;[|B|];a]
      | []   -> yield Array.init i (fun _ -> B)
    ]
    fi n i
  static member fi n i = Array.map2 (fun n g -> match (n,g) with |X,X->X |B,B->B |_->V) n i
  static member fg (n: N[]) (i: N[][]) g = n |> Seq.mapi (fun e n -> i.[e].[g] = n || i.[e].[g] = V) |> Seq.forall (fun n -> n)
  static member fe (n: N[][]) = n|> Array.forall (fun n -> Array.forall (fun n -> n <> V) n)
  static member fl n = n |> Array.Parallel.map (fun n -> Seq.reduce (fun n g -> N.fi n g) n)
  static member fa (nga: list<N []>[]) ngb = Array.Parallel.mapi (fun i n -> List.filter (fun n -> N.fg n ngb i) n) nga
  static member fo n i g e =
    let na = N.fa n e
    let ia = N.fl na
    let ga = N.fa g ia
    (na, ia, ga, (N.fl ga))
  static member toStr n = match n with |X->"X"|B->"."|V->"?"
  static member presolve ((na: list<N []>[]), (ga: list<N []>[])) =
    let nb = N.fl na
    let x = N.fa ga nb
    let rec fn n i g e l =
      let na,ia,ga,ea = N.fo n i g e
      let el = ((Array.map (fun n -> List.length n) na), (Array.map (fun n -> List.length n) ga))
      if ((fst el) = (fst l)) && ((snd el) = (snd l)) then (n,i,g,e,(Array.forall (fun n -> n = 1) (fst l))) else fn na ia ga ea el
    fn na nb x (N.fl x) ((Array.map (fun n -> List.length n) na), (Array.map (fun n -> List.length n) ga))
