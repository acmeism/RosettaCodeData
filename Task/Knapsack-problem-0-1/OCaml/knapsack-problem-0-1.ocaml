let items = [
  "map",                     9,  150;
  "compass",                13,   35;
  "water",                 153,  200;
  "sandwich",               50,  160;
  "glucose",                15,   60;
  "tin",                    68,   45;
  "banana",                 27,   60;
  "apple",                  39,   40;
  "cheese",                 23,   30;
  "beer",                   52,   10;
  "suntan cream",           11,   70;
  "camera",                 32,   30;
  "t-shirt",                24,   15;
  "trousers",               48,   10;
  "umbrella",               73,   40;
  "waterproof trousers",    42,   70;
  "waterproof overclothes", 43,   75;
  "note-case",              22,   80;
  "sunglasses",              7,   20;
  "towel",                  18,   12;
  "socks",                   4,   50;
  "book",                   30,   10;
]

let comb =
  List.fold_left (fun acc x -> let acc2 = List.rev_map (fun li -> x::li) acc in
                                 List.rev_append acc acc2) [[]]

let score =
  List.fold_left (fun (w_tot,v_tot) (_,w,v) -> (w + w_tot, v + v_tot)) (0,0)

let () =
  let combs = comb items in
  let vals = List.rev_map (fun this -> (score this, this)) combs in
  let poss = List.filter (fun ((w,_), _) -> w <= 400) vals in
  let _, res = List.fold_left (fun (((_,s1),_) as v1) (((_,s2),_) as v2) ->
                 if s2 > s1 then v2 else v1)
                 (List.hd poss) (List.tl poss) in
  List.iter (fun (name,_,_) -> print_endline name) res;
;;
