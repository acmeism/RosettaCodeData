import Foundation

func commonPrefix<T: Equatable>(_ lhs: [T], _ rhs: [T]) -> [T] {
	for tryLen in (0...min(lhs.count,rhs.count)).reversed() {
		if lhs.starts(with: rhs.prefix(tryLen)) {
			return Array<T>(rhs.prefix(tryLen))
		}
	}
	return []
}

var test = ["/home/user1/tmp/coverage/test",
		    "/home/user1/tmp/covert/operator",
		    "/home/user1/tmp/coven/members"]

let lcp: String = test.reduce("") { lhs, rhs in
	if !lhs.isEmpty {
		var commonSoFar = commonPrefix(
			lhs.components(separatedBy: "/"),
			rhs.components(separatedBy: "/")
		)
		return commonSoFar.joined(separator: "/")
	}
	return rhs
}
print("Longest common path: \(lcp)")

// Longest common path: /home/user1/tmp
