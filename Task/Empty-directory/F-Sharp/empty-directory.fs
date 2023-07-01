open System.IO
let isEmptyDirectory x = (Directory.GetFiles x).Length = 0 && (Directory.GetDirectories x).Length = 0
