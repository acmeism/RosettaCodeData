open System
open System.IO

type Tree<'a> =
   | Tree of 'a * Tree<'a> * Tree<'a>
   | Empty

let rec inorder tree =
    seq {
      match tree with
          | Tree(x, left, right) ->
               yield! inorder left
               yield x
               yield! inorder right
          | Empty -> ()
    }

let rec preorder tree =
    seq {
      match tree with
          | Tree(x, left, right) ->
               yield x
               yield! preorder left
               yield! preorder right
          | Empty -> ()
    }

let rec postorder tree =
    seq {
      match tree with
          | Tree(x, left, right) ->
               yield! postorder left
               yield! postorder right
               yield x
          | Empty -> ()
    }

let levelorder tree =
    let rec loop queue =
        seq {
            match queue with
            | [] -> ()
            | (Empty::tail) -> yield! loop tail
            | (Tree(x, l, r)::tail) ->
                yield x
                yield! loop (tail @ [l; r])
        }
    loop [tree]

[<EntryPoint>]
let main _ =
    let tree =
        Tree (1,
              Tree (2,
                    Tree (4,
                          Tree (7, Empty, Empty),
                          Empty),
                    Tree (5, Empty, Empty)),
              Tree (3,
                    Tree (6,
                          Tree (8, Empty, Empty),
                          Tree (9, Empty, Empty)),
                    Empty))

    let show x = printf "%d " x

    printf "preorder:    "
    preorder tree   |> Seq.iter show
    printf "\ninorder:     "
    inorder tree    |> Seq.iter show
    printf "\npostorder:   "
    postorder tree  |> Seq.iter show
    printf "\nlevel-order: "
    levelorder tree |> Seq.iter show
    0
