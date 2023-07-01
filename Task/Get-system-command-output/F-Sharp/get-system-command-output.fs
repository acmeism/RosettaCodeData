// System Command Output. Nigel Galloway: October 6th., 2020
let n=new System.Diagnostics.Process(StartInfo=System.Diagnostics.ProcessStartInfo(RedirectStandardOutput=true,RedirectStandardError=true,UseShellExecute=false,
          FileName= @"C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\IDE\CommonExtensions\Microsoft\FSharp\fsc.exe",Arguments="--help"))
n.Start()
printfn "%s" ((n.StandardOutput).ReadToEnd())
n.Close()
