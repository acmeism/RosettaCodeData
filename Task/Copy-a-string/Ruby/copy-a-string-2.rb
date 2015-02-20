original = "hello".freeze     # prevents further modifications
copy1 = original.dup          # copies contents (without status)
copy2 = original.clone        # copies contents (with status)
p copy1.frozen?               #=> false
p copy1 << " world!"          #=> "hello world!"
p copy2.frozen?               #=> true
p copy2 << " world!"          #=> can't modify frozen String (RuntimeError)
