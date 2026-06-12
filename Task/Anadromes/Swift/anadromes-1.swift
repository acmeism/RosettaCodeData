import Foundation
import Algorithms

extension String {
	var firstAndLast: String { String(self.first!) + String(self.last!) }
	var backwards: String { String(self.reversed()) }
}

class AnadromeIndex {

		// Stucture to index by length and the first and last character
		// [ length: [ firstAndLast: [ words ] ] ]
		/// Only compare words of same length, and where
		/// firstAndLast corresponds to its reverse
	var dict: [Int: [String: [String]]] = [:]

	func loadFile(
		fileURL: URL,
		minLen: Int,
		byLine: Bool = false
	) async -> (Int, Int) {
		var linesRead = 0
		var wordsIndexed = 0
		do {
			if byLine {
				for try await line in fileURL.lines {
					linesRead += 1
					if line.count < minLen { continue }
					wordsIndexed += 1
					self.addWord( line
						.trimmingCharacters(in: .whitespacesAndNewlines)
					)
				}
			} else {
				let fileString = try String(contentsOf: fileURL, encoding: .utf8)
				for line in fileString.components(separatedBy: .newlines) {
					linesRead += 1
					if line.count < minLen { continue }
					wordsIndexed += 1
					self.addWord( line
						.trimmingCharacters(in: .whitespacesAndNewlines)
					)
				}
			}
		} catch {
			debugPrint(error)
		}
		return (linesRead, wordsIndexed)
	}

	func addWord(_ str: String) {
		let len = str.count
		let index = str.firstAndLast
		if let azDict = dict[len] {
			if azDict[index] != nil {
				self.dict[len]![index]!.append(str)
			} else {
				self.dict[len]!.updateValue([str], forKey: index)
			}
		} else {
			dict.updateValue([index: [str]], forKey: len)
		}
	}

	func findAnadromes() async -> [String] {
		var done: [String] = []
		var results: [String] = []
		let allResults = await withTaskGroup(
			of: [String].self,
			returning: [String].self) { group in
				// By length
			for len in self.dict.keys.sorted() {
				if let lenSet = self.dict[len] {
						// By firstAndLast characters
					for az in lenSet.keys.sorted() {
						let za = az.backwards
						if done.contains(where: { $0 == "\(len)\(az)" || $0 == "\(len)\(za)" })
								|| lenSet[za] == nil { continue }
						done += ["\(len)\(az)", "\(len)\(za)"]
						group.addTask {
							let lh = lenSet[az]!
							let rh = lenSet[za]!
							let f = await self.searchProduct(lh: lh, rh: rh)
							return f
						}
					}
				}
			}
			for await result in group {
				results += result
			}
			return results
		}
		return allResults
	}

	func searchProduct(lh: [String], rh: [String]) async -> [String] {
		var found: [String] = []
		for ( s1, s2 ) in product(lh, rh) {
			if s1 == s2 { continue } // palindrome
			if s1 == String(s2.reversed())
					&& !found.contains(where: {$0 == s2 || $0 == s1}) {
				found.append(s1)
			}
		}
		return found
	}
}
