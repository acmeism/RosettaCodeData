let d =
  [ "alliance", -624;  "archbishop", -915;  "balm", 397;  "bonnet", 452;
    "brute", 870;  "centipede", -658;  "cobol", 362;  "covariate", 590;
    "departure", 952;  "deploy", 44;  "diophantine", 645;  "efferent", 54;
    "elysee", -326;  "eradicate", 376;  "escritoire", 856;  "exorcism", -983;
    "fiat", 170;  "filmy", -874;  "flatworm", 503;  "gestapo", 915;
    "infra", -847;  "isis", -982;  "lindholm", 999;  "markham", 475;
    "mincemeat", -880;  "moresby", 756;  "mycenae", 183;  "plugging", -266;
    "smokescreen", 423;  "speakeasy", -745;  "vein", 813; ]

let sum = List.fold_left (fun sum (_,w) -> sum + w) 0
let p = function [] -> false | lst -> (sum lst) = 0

let take lst set =
  let x = List.nth set (Random.int (List.length set)) in
  (x::lst, List.filter (fun y -> y <> x) set)

let swap (a, b) = (b, a)
let pop lst set = swap (take set lst)

let () =
  Random.self_init ();
  let rec aux lst set =
    let f =
      match lst, set with
      | [], _ -> take
      | _, [] -> pop
      | _ -> if Random.bool () then take else pop
    in
    let lst, set = f lst set in
    if p lst then lst
    else aux lst set
  in
  let res = aux [] d in
  List.iter (fun (n,w) -> Printf.printf " %4d\t%s\n" w n) res
