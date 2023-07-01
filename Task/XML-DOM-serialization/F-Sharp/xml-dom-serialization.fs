open System.Xml

[<EntryPoint>]
let main argv =
    let xd = new XmlDocument()
    // Create the required nodes:
    xd.AppendChild (xd.CreateXmlDeclaration("1.0", null, null)) |> ignore
    let root = xd.AppendChild (xd.CreateNode("element", "root", ""))
    let element = root.AppendChild (xd.CreateElement("element", "element", ""))
    element.AppendChild (xd.CreateTextNode("Some text here")) |> ignore
    // The same can be accomplished with:
    // xd.LoadXml("""<?xml version="1.0"?><root><element>Some text here</element></root>""")

    let xw = new XmlTextWriter(System.Console.Out)
    xw.Formatting <- Formatting.Indented
    xd.WriteContentTo(xw)
    0
