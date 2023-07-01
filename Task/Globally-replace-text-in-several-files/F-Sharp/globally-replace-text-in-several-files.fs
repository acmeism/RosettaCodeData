open System.IO

[<EntryPoint>]
let main args =
    let textFrom = "Goodbye London!"
    let textTo = "Hello New York!"
    for name in args do
        let content = File.ReadAllText(name)
        let newContent = content.Replace(textFrom, textTo)
        if content <> newContent then
            File.WriteAllText(name, newContent)
    0
