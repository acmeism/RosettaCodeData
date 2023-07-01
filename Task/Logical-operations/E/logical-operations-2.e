def logicalOperations(a :boolean, b :boolean) {
    return ["and" => a.and(b),
            "or"  => a.or(b),
            "not" => a.not(),
            "xor" => a.xor(b)]
}
