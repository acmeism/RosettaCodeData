 let x = "lions, tigers, and"
 let y = "bears, oh my!"
 let z = """(from the "Wizard of OZ")"""
 List.iter (printfn "%s") (List.sort [x;y;z])
