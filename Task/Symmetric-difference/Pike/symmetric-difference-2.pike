> array(string) A = ({ "John", "Serena", "Bob", "Mary", "Serena", "Bob" });
> array(string) B = ({ "Jim", "Mary", "John", "Jim", "Bob", "Mary" });
> A^B;
Result: ({ "Serena", "Serena", "Bob", "Jim", "Jim", "Mary"})

> Array.uniq((A-B)+(B-A));
Result: ({ "Serena", "Jim" })
