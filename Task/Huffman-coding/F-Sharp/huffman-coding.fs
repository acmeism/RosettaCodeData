type 'a HuffmanTree =
    | Leaf of int * 'a
    | Node of int * 'a HuffmanTree * 'a HuffmanTree

let freq = function Leaf (f, _) | Node (f, _, _) -> f
let freqCompare a b = compare (freq a) (freq b)

let buildTree charFreqs =
    let leaves = List.map (fun (c,f) -> Leaf (f,c)) charFreqs
    let freqSort = List.sortWith freqCompare
    let rec aux = function
        | [] -> failwith "empty list"
        | [a] -> a
        | a::b::tl ->
            let node = Node(freq a + freq b, a, b)
            aux (freqSort(node::tl))
    aux (freqSort leaves)

let rec printTree = function
  | code, Leaf (f, c) ->
      printfn "%c\t%d\t%s" c f (String.concat "" (List.rev code));
  | code, Node (_, l, r) ->
      printTree ("0"::code, l);
      printTree ("1"::code, r)

let () =
  let str = "this is an example for huffman encoding"
  let charFreqs =
    str |> Seq.groupBy id
        |> Seq.map (fun (c, vals) -> (c, Seq.length vals))
        |> Map.ofSeq

  let tree = charFreqs |> Map.toList |> buildTree
  printfn "Symbol\tWeight\tHuffman code";
  printTree ([], tree)
