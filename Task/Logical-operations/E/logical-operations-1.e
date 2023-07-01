def logicalOperations(a :boolean, b :boolean) {
    return ["and" => a & b,
            "or"  => a | b,
            "not" => !a,
            "xor" => a ^ b]
}
