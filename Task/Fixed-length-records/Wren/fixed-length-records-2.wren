import "./ioutil" for File, FileUtil
import "./str" for Str

var blockToText = Fn.new { |blockFileName, textFileName|
    var block = File.read(blockFileName)
    var lb = FileUtil.lineBreak
    File.create(textFileName) { |f|
        for (chunk in Str.chunks(block, 64)) {
            f.writeBytes(chunk.trimEnd() + lb)
        }
    }
}

var textToBlock = Fn.new { |textFileName, blockFileName|
    var lines = FileUtil.readLines(textFileName).where { |l| l != "" }.toList
    var text = lines.map { |l| (l.count < 64) ? l + (" " * (64-l.count)) : l[0..63] }.join()
    var rem = text.count % 1024
    if (rem > 0) text = text + (" " * (1024 - rem))
    File.create(blockFileName) { |f| f.writeBytes(text) }
}

// create a block file
File.create("data.blk") { |f|
    f.writeBytes("a" * 1024)
    f.writeBytes("b" * 1024)
    f.writeBytes("c" * 1024)
    f.writeBytes("d" * 1024)
}

blockToText.call("data.blk", "data.txt")
textToBlock.call("data.txt", "data2.blk")
System.print(FileUtil.areDuplicates("data.blk", "data2.blk"))
