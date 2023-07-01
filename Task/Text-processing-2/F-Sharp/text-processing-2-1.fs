let file = @"readings.txt"

let dates = HashSet(HashIdentity.Structural)
let mutable ok = 0

do
  for line in System.IO.File.ReadAllLines file do
    match String.split [' '; '\t'] line with
    | [] -> ()
    | date::xys ->
        if dates.Contains date then
          printf "Date %s is duplicated\n" date
        else
          dates.Add date
        let f (b, t) h = not b, if b then int h::t else t
        let _, states = Seq.fold f (false, []) xys
        if Seq.forall (fun s -> s >= 1) states then
          ok <- ok + 1
  printf "%d records were ok\n" ok
