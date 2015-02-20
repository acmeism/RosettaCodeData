val names = List("April", "Tam O'Shanter", "Emily")

val remarks = List("Bubbly: I'm > Tam and <= Emily", """Burns: "When chapman billies leave the street ..."""", "Short & shrift")

def characterRemarks(names: List[String], remarks: List[String]) = <CharacterRemarks>
  { names zip remarks map { case (name, remark) => <Character name={name}>{remark}</Character> } }
</CharacterRemarks>

characterRemarks(names, remarks)
