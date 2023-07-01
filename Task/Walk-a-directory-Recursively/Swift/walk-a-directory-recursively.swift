import Foundation

let fileSystem = FileManager.default
let rootPath = "/"

// Enumerate the directory tree (which likely recurses internally)...

if let fsTree = fileSystem.enumerator(atPath: rootPath) {
	
    while let fsNodeName = fsTree.nextObject() as? NSString {
				
        let fullPath = "\(rootPath)/\(fsNodeName)"
				
        var isDir: ObjCBool = false
        fileSystem.fileExists(atPath: fullPath, isDirectory: &isDir)
				
        if !isDir.boolValue && fsNodeName.pathExtension == "txt" {
            print(fsNodeName)
        }
    }
}
