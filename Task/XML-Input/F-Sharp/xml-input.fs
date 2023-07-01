open System.IO
open System.Xml
open System.Xml.Linq

let xn s = XName.Get(s)

let xd = XDocument.Load(new StringReader("""
<Students>
  <Student Name="April" Gender="F" DateOfBirth="1989-01-02" />
  <Student Name="Bob" Gender="M"  DateOfBirth="1990-03-04" />
  <Student Name="Chad" Gender="M"  DateOfBirth="1991-05-06" />
  <Student Name="Dave" Gender="M"  DateOfBirth="1992-07-08">
    <Pet Type="dog" Name="Rover" />
  </Student>
  <Student DateOfBirth="1993-09-10" Gender="F" Name="&#x00C9;mily" />
</Students>
"""))  // "



[<EntryPoint>]
let main argv =
    let students = xd.Descendants <| xn "Student"
    let names = students.Attributes <| xn "Name"
    Seq.iter ((fun (a : XAttribute) ->  a.Value) >> printfn "%s") names
    0
