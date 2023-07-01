try
    BadlyCodedFunc()
catch e
    MsgBox % "Error in " e.What ", which was called at line " e.Line

BadlyCodedFunc() {
    throw Exception("Fail", -1)
}
