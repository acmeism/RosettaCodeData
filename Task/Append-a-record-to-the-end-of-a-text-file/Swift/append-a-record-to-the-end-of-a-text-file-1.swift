import Foundation

func appendPasswd(
	account: String,
	passwd: String,
	uid: Int,
	gid: Int,
	bio: String,
	home: String,
	shell: String
) {
	let str = [
		account,
		passwd,
		String(uid),
		String(gid),
		bio,
		home,
		shell
	].joined(separator: ":").appending("\n")
	guard let data = str.data(using: .utf8) else { return }
	let url = URL(fileURLWithPath: "./passwd")
	do {
		if let fileHandle = try? FileHandle(forWritingTo: url) {
			fileHandle.seekToEndOfFile()
			fileHandle.write(data)
			try? fileHandle.close()
		} else {
			try data.write(to: url)
		}
	} catch {
		print(error)
	}
}
