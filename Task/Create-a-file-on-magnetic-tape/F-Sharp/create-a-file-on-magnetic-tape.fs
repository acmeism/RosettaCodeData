open System
open System.IO

let env = Environment.OSVersion.Platform
let msg = "Hello Rosetta!"

match env with
    | PlatformID.Win32NT | PlatformID.Win32S | PlatformID.Win32Windows | PlatformID.WinCE -> File.WriteAllText("TAPE.FILE", msg)
    | _ -> File.WriteAllText("/dev/tape", msg)
