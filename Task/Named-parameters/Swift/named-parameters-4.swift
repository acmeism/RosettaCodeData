func greet(person: String, from hometown: String = "Cupertino") -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
print(greet(person: "Bill"))
