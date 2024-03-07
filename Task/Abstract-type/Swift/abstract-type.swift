protocol Pet {
	var name: String { get set }
	var favouriteToy: String { get set }

	func feed() -> Bool

	func stroke() -> Void

}

extension Pet {
    // Default implementation must be in an extension, not in the declaration above

    func stroke() {
		print("default purr")
	}
}

struct Dog: Pet {
	var name: String
	var favouriteToy: String
	
	// Required implementation
	func feed() -> Bool {
		print("more please")
		return false
	}
	// If this were not implemented, the default from the extension above
	// would be called.
	func stroke() {
		print("roll over")
	}
}
