datatype 'a huffman_tree =
         Leaf of 'a
       | Node of 'a huffman_tree * 'a huffman_tree

structure HuffmanPriority = struct
  type priority = int
(* reverse comparison to achieve min-heap *)
  fun compare (a, b) = Int.compare (b, a)
  type item = int * char huffman_tree
  val priority : item -> int = #1
end

structure HPQueue = LeftPriorityQFn (HuffmanPriority)

fun buildTree charFreqs = let
    fun aux trees = let
        val ((f1,a), trees) = HPQueue.remove trees
    in
        if HPQueue.isEmpty trees then
            a
        else let
                val ((f2,b), trees) = HPQueue.remove trees
                val trees = HPQueue.insert ((f1 + f2, Node (a, b)),
                                            trees)
            in
                aux trees
            end
    end
    val trees = HPQueue.fromList (map (fn (c,f) => (f, Leaf c)) charFreqs)
in
    aux trees
end

fun printCodes (revPrefix, Leaf c) =
    print (String.str c ^ "\t" ^
           implode (rev revPrefix) ^ "\n")
  | printCodes (revPrefix, Node (l, r)) = (
    printCodes (#"0"::revPrefix, l);
    printCodes (#"1"::revPrefix, r)
    );

let
    val test = "this is an example for huffman encoding"
    val charFreqs = HashTable.mkTable
                        (HashString.hashString o String.str, op=)
                        (42, Empty)
    val () =
        app (fn c =>
                let val old = getOpt (HashTable.find charFreqs c, 0)
                in HashTable.insert charFreqs (c, old+1)
                end)
            (explode test)
    val tree = buildTree (HashTable.listItemsi charFreqs)
in
    print "SYMBOL\tHUFFMAN CODE\n";
    printCodes ([], tree)
end
