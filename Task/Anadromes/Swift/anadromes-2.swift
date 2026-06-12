import Foundation
import ArgumentParser

@main
struct AnadromeFinder: AsyncParsableCommand {
	@Argument(help: "File containing words", transform: URL.init(fileURLWithPath:))
	var file: URL

	@Option(name: .shortAndLong)
	var minLen: Int = 6

	@Flag(name: .shortAndLong)
	var verbose = false

	mutating func run() async throws {
		let indexSet = AnadromeIndex()
		var start = Date()
		let (lines, words) = await indexSet.loadFile(fileURL: file, minLen: minLen)
		if verbose {
			printStderr("\(lines.formatted()) lines read,",
									"\(words.formatted()) hashed in",
									"\(since(start).formatted()) sec")
		}
		start = Date()
		let found = await indexSet.findAnadromes()
		if verbose {
			printStderr("\(found.count.formatted()) matches found in",
									"\(since(start)) seconds")
		}
			// Print results
		for e in found.sorted(by: {a, b in
			if a.count == b.count { return a < b }
			return a.count < b.count
		}) {
			print(e, e.backwards)
		}
	}
	func since(_ dt: Date) -> TimeInterval {
		return Date().timeIntervalSince(dt)
	}
	func printStderr(
		_ items: Any...,
		separator: String = " ",
		terminator: String = "\n"
	) {
		let output = items
			.map { String(describing: $0) }
			.joined(separator: separator) + terminator
		FileHandle.standardError.write(output.data(using: .utf8)!)
	}
}
