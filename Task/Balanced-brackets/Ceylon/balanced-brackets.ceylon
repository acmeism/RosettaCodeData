import com.vasileff.ceylon.random.api {
    platformRandom,
    Random
}
"""Run the example code for Rosetta Code ["Balanced brackets" task] (http://rosettacode.org/wiki/Balanced_brackets)."""
shared void run() {
    value rnd = platformRandom();
    for (len in (0..10)) {
        value c = generate(rnd, len);
        print("``c.padTrailing(20)`` - ``if (balanced(c)) then "OK" else "NOT OK" ``");
    }
}

String generate(Random rnd, Integer count)
        => if (count == 0) then ""
           else let(length = 2*count,
                    brackets = zipEntries(rnd.integers(length).take(length),
                                          "[]".repeat(count))
                            .sort((a,b) => a.key<=>b.key)
                            .map(Entry.item))
                String(brackets);

Boolean balanced(String input)
        => let (value ints = { for (c in input) if (c == '[') then 1 else -1 })
           ints.filter((i) => i != 0)
               .scan(0)(plus<Integer>)
               .every((i) => i >= 0);
