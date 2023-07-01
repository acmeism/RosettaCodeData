#light

open System.Xml
type Character = {name : string; comment : string }

let data = [
    { name = "April"; comment = "Bubbly: I'm > Tam and <= Emily"}
    { name = "Tam O'Shanter"; comment = "Burns: \"When chapman billies leave the street ...\""}
    { name = "Emily"; comment = "Short & shrift"} ]

let doxml (characters : Character list) =
    let doc = new XmlDocument()
    let root = doc.CreateElement("CharacterRemarks")
    doc.AppendChild root |> ignore
    Seq.iter (fun who ->
             let node = doc.CreateElement("Character")
             node.SetAttribute("name", who.name)
             doc.CreateTextNode(who.comment)
             |> node.AppendChild |> ignore
             root.AppendChild node |> ignore
             ) characters
    doc.OuterXml
