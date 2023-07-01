    namespace RosettaCode

    type BinaryTree<'T> =
      | Element of 'T
      | Tree of 'T * BinaryTree<'T> * BinaryTree<'T>
      member this.Map(f) =
        match this with
        | Element(x) -> Element(f x)
        | Tree(x,left,right) -> Tree((f x), left.Map(f), right.Map(f))
