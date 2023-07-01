struct Example {
    var notSoSecret = "Hello!"
    private var secret = 42
}

let e = Example()
let mirror = Mirror(reflecting: e)

if let secret = mirror.children.filter({ $0.label == "secret" }).first?.value {
    print("Value of the secret is \(secret)")
}
