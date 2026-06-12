var conjugate = Fn.new { |infinitive|
    if (!infinitive.endsWith("are")) Fiber.abort("Not a first conjugation verb.")
    var stem = infinitive[0...-3]
    if (stem.count == 0) Fiber.abort("Stem cannot be empty.")
    System.print("Present indicative tense of '%(infinitive)':")
    for (ending in ["o", "as", "at", "amus", "atis", "ant"]) {
        System.print("  " + stem + ending)
    }
    System.print()
}

for (infinitive in ["amare", "dare"]) conjugate.call(infinitive)
