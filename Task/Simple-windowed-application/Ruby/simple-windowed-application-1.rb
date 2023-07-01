require 'tk'
str = TkVariable.new("no clicks yet")
count = 0
root = TkRoot.new
TkLabel.new(root, "textvariable" => str).pack
TkButton.new(root) do
  text "click me"
  command {str.value = count += 1}
  pack
end
Tk.mainloop
