let str = "hello"
let additionalReference = str
let deepCopy = System.String.Copy( str )

printfn "%b" <| System.Object.ReferenceEquals( str, additionalReference ) // prints true
printfn "%b" <| System.Object.ReferenceEquals( str, deepCopy )            // prints false
