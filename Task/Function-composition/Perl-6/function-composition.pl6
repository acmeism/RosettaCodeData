sub triple($n) { 3 * $n }
my &f = &triple ∘ &[-] ∘ { $^n + 2 };
say &f(5); # Prints "-21".
