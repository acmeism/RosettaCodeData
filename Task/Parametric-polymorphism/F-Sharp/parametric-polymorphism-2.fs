    let t1 = Tree(2, Element(1), Tree(4,Element(3),Element(5)) )
    let t2 = t1.Map(fun x -> x * 10)
