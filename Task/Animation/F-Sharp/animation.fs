open System.Windows

let str = "Hello world! "
let mutable i = 0
let mutable d = 1

[<System.STAThread>]
do
  let button = Controls.Button()
  button.Click.Add(fun _ -> d <- str.Length - d)
  let update _ =
    i <- (i + d) % str.Length
    button.Content <- str.[i..] + str.[..i-1]
  Media.CompositionTarget.Rendering.Add update
  (Application()).Run(Window(Content=button)) |> ignore
