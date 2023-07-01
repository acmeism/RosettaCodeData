type Table(rows:string[][]) =
   // in-place sorting of rows
   member x.Sort(?ordering, ?column, ?reverse) =
      let ordering = defaultArg ordering compare
      let column   = defaultArg column   0
      let reverse  = defaultArg reverse  false

      let factor = if reverse then -1 else 1
      let comparer (row1:string[]) (row2:string[]) =
         factor * ordering row1.[column] row2.[column]

      Array.sortInPlaceWith comparer rows

   member x.Print() =
      for row in rows do printfn "%A" row

// Example usage
let t = new Table([| [|"a";   "b"; "c"|]
                     [|"";    "q"; "z"|]
                     [|"can"; "z"; "a"|] |])

printfn "Unsorted"; t.Print()

t.Sort()
printfn "Default sort"; t.Print()

t.Sort(column=2)
printfn "Sorted by col. 2"; t.Print()

t.Sort(column=1)
printfn "Sorted by col. 1"; t.Print()

t.Sort(column=1, reverse=true)
printfn "Reverse sorted by col. 1"; t.Print()

t.Sort(ordering=fun s1 s2 -> compare s2.Length s1.Length)
printfn "Sorted by decreasing length"; t.Print()
