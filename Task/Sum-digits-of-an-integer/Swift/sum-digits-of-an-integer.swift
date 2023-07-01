extension String: Error {
    func sumDigits(withBase base: Int) throws -> Int {
        func characterToInt(_ base: Int) -> (Character) -> Int? {
            return { char in
                return Int(String(char), radix: base)
            }
        }

        return try self.map(characterToInt(base))
            .flatMap {
                guard $0 != nil else { throw "Invalid input" }
                return $0
            }
            .reduce(0, +)
    }
}

print(try! "1".sumDigits(withBase: 10))
print(try! "1234".sumDigits(withBase: 10))
print(try! "fe".sumDigits(withBase: 16))
print(try! "f0e".sumDigits(withBase: 16))
