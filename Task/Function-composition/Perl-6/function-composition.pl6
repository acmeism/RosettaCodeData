sub triple($n) { 3 * $n }
my &f = &triple ∘ &prefix:<-> ∘ { $^n + 2 };
say &f(5); # Prints "-21".
