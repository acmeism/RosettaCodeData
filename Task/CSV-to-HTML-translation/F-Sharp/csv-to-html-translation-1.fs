open System
open System.Text
open System.Xml

let data = """
Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!
"""

let csv =
    Array.map
        (fun (line : string) -> line.Split(','))
        (data.Trim().Split([|'\n';'\r'|],StringSplitOptions.RemoveEmptyEntries))


[<EntryPoint>]
let main argv =
    let style = argv.Length > 0 && argv.[0] = "-h"
    Console.OutputEncoding <- UTF8Encoding()
    let xs = XmlWriterSettings()
    xs.Indent <- true   // be friendly to humans
    use x = XmlWriter.Create(Console.Out, xs)
    x.WriteStartDocument()
    x.WriteDocType("HTML", null, null, null)    // HTML5
    x.WriteStartElement("html")
    x.WriteStartElement("head")
    x.WriteElementString("title", "Rosettacode - CSV to HTML translation")
    if style then
        x.WriteStartElement("style"); x.WriteAttributeString("type", "text/css")
        x.WriteString("""
            table { border-collapse: collapse; }
            td, th { border: 1px solid black; padding: .25em}
            th { background-color: #EEE; }
            tbody th { font-weight: normal; font-size: 85%; }
        """)
        x.WriteEndElement() // style
    x.WriteEndElement() // head
    x.WriteStartElement("body")
    x.WriteStartElement("table")
    x.WriteStartElement("thead"); x.WriteStartElement("tr")
    for part in csv.[0] do x.WriteElementString("th", part)
    x.WriteEndElement(); x.WriteEndElement() // tr thead
    x.WriteStartElement("tbody")
    for line in csv.[1..] do
        x.WriteStartElement("tr")
        x.WriteElementString("th", line.[0])
        x.WriteElementString("td", line.[1])
        x.WriteEndElement() // tr
    x.Close()
    0
