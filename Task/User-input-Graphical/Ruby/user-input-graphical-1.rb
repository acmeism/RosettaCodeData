require 'tk'

def main
  root = TkRoot.new
  l1 = TkLabel.new(root, "text" => "input a string")
  e1 = TkEntry.new(root)
  l2 = TkLabel.new(root, "text" => "input the number 75000")
  e2 = TkEntry.new(root) do
    validate "focusout"
    validatecommand lambda {e2.value.to_i == 75_000}
    invalidcommand  lambda {focus_number_entry(e2)}
  end
  ok = TkButton.new(root) do
    text "OK"
    command lambda {validate_input(e1, e2)}
  end
  Tk.grid(l1, e1)
  Tk.grid(l2, e2)
  Tk.grid("x",ok, "sticky" => "w")
  Tk.mainloop
end

def validate_input(text_entry, number_entry)
  if number_entry.value.to_i != 75_000
    focus_number_entry(number_entry)
  else
    puts %Q{You entered: "#{text_entry.value}" and "#{number_entry.value}"}
    root.destroy
  end
end

def focus_number_entry(widget)
  widget \
    .configure("background" => "red", "foreground" => "white") \
    .selection_range(0, "end") \
    .focus
end

main
