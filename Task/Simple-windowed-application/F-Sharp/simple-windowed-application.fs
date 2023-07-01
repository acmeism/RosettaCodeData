open System.Windows.Forms

let mutable clickCount = 0

let form = new Form()

let label = new Label(Text = "There have been no clicks yet.", Dock = DockStyle.Top)
form.Controls.Add(label)

let button = new Button(Text = "Click me", Dock = DockStyle.Bottom)
button.Click.Add(fun _ ->
    clickCount <- clickCount+1
    label.Text <- sprintf "Number of clicks: %i." clickCount)
form.Controls.Add(button)

Application.Run(form)
