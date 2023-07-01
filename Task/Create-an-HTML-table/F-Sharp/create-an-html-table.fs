open System.Xml

type XmlDocument with
    member this.Add element =
        this.AppendChild element
    member this.Element name =
        this.CreateElement(name) :> XmlNode
    member this.Element (name, (attr : (string * string) list)) =
        let node = this.CreateElement(name)
        for a in attr do
            node.SetAttribute (fst a, snd a)
        node
    member this.Element (name, (text : string)) =
        let node = this.CreateElement(name)
        node.AppendChild(this.Text text) |> ignore
        node
    member this.Text text =
        this.CreateTextNode(text)
    end

type XmlNode with
    member this.Add element =
        this.AppendChild element
    end

let head = [""; "X"; "Y"; "Z"]

let xd = new XmlDocument()
let html = xd.Add (xd.Element("html"))
html.Add(xd.Element("head"))
    .Add(xd.Element("title", "RosettaCode: Create_an_HTML_table"))
let table = html.Add(xd.Element("body")).Add(xd.Element("table", [("style", "text-align:right")]))
let tr1 = table.Add(xd.Element("tr"))
for th in head do
    tr1.Add(xd.Element("th", th)) |> ignore
for i in [1; 2; 3] do
    let tr = table.Add(xd.Element("tr"))
    tr.Add(xd.Element("th", i.ToString())) |> ignore
    for j in [1; 2; 3] do
        tr.Add(xd.Element("td", ((i-1)*3+j+1000).ToString())) |> ignore

let xw = new XmlTextWriter(System.Console.Out)
xw.Formatting <- Formatting.Indented
xd.WriteContentTo(xw)
