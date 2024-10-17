module FIFO : sig
  type 'a fifo
  val empty: 'a fifo
  val push: fifo:'a fifo -> item:'a -> 'a fifo
  val pop: fifo:'a fifo -> 'a * 'a fifo
  val is_empty: fifo:'a fifo -> bool
end = struct
  type 'a fifo = 'a list * 'a list
  let empty = [], []
  let push ~fifo:(input,output) ~item = (item::input,output)
  let is_empty ~fifo =
    match fifo with
    | [], [] -> true
    | _ -> false
  let rec pop ~fifo =
    match fifo with
    | input, item :: output -> item, (input,output)
    | [], [] -> failwith "empty fifo"
    | input, [] -> pop ([], List.rev input)
end
