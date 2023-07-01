let rec countInOctal num : unit =
  printfn "%o" num
  countInOctal (num + 1)

countInOctal 1
