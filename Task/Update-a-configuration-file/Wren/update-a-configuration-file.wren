import "io" for File
import "./ioutil" for FileUtil
import "./dynamic" for Tuple
import "./str" for Str

var fields = ["favouriteFruit", "needsPeeling", "seedsRemoved", "numberOfBananas", "numberOfStrawberries"]
var ConfigData = Tuple.create("ConfigData", fields)

var updateConfigFile = Fn.new { |fileName, cData|
    var lines = File.read(fileName).trimEnd().split(FileUtil.lineBreak)
    var tempFileName = "temp_%(fileName)"
    var out = File.create(tempFileName)
    var hadFruit = false
    var hadPeeling = false
    var hadSeeds = false
    var hadBananas = false
    var hadStrawberries = false

    for (line in lines) {
        var cont = false
        if (line.isEmpty || line[0] == "#") {
            out.writeBytes(line + "\n")
            cont = true
        }
        if (!cont) {
            var ln = Str.upper(line.trimStart(";").trim())
            if (!ln.isEmpty) {
                if (ln.take(14).join() == "FAVOURITEFRUIT") {
                    if (!hadFruit) {
                        hadFruit = true
                        out.writeBytes("FAVOURITEFRUIT %(cData.favouriteFruit)\n")
                    }
                } else if (ln.take(12).join() == "NEEDSPEELING") {
                    if (!hadPeeling) {
                        hadPeeling = true
                        if (cData.needsPeeling) {
                            out.writeBytes("NEEDSPEELING\n")
                        } else {
                            out.writeBytes("; NEEDSPEELING\n")
                        }
                    }
                } else if (ln.take(12).join() == "SEEDSREMOVED") {
                    if (!hadSeeds) {
                        hadSeeds = true
                        if (cData.seedsRemoved) {
                            out.writeBytes("SEEDSREMOVED\n")
                        } else {
                            out.writeBytes("; SEEDSREMOVED\n")
                        }
                    }
                } else if (ln.take(15).join() == "NUMBEROFBANANAS") {
                    if (!hadBananas) {
                        hadBananas = true
                        out.writeBytes("NUMBEROFBANANAS %(cData.numberOfBananas)\n")
                    }
                } else if (ln.take(20).join() == "NUMBEROFSTRAWBERRIES") {
                    if (!hadStrawberries) {
                        hadStrawberries = true
                        out.writeBytes("NUMBEROFSTRAWBERRIES %(cData.numberOfStrawberries)\n")
                    }
                }
            }
        }
    }

    if (!hadFruit) {
        out.writeBytes("FAVOURITEFRUIT %(cData.favouriteFruit)\n")
    }

    if (!hadPeeling) {
        if (cData.needsPeeling) {
            out.writeBytes("NEEDSPEELING\n")
        } else {
            out.writeBytes("; NEEDSPEELING\n")
        }
    }

    if (!hadSeeds) {
        if (cData.seedsRemoved) {
            out.writeBytes("SEEDSREMOVED\n")
        } else {
            out.writeBytes("; SEEDSREMOVED\n")
        }
    }

    if (!hadBananas) {
        out.writeBytes("NUMBEROFBANANAS %(cData.numberOfBananas)\n")
    }

    if (!hadStrawberries) {
        out.writeBytes("NUMBEROFSTRAWBERRIES %(cData.numberOfStrawberries)\n")
    }

    out.close()
    FileUtil.move(tempFileName, fileName, true)
}

var fileName = "config.txt"
var cData = ConfigData.new("banana", false, true, 1024, 62000)
updateConfigFile.call(fileName, cData)
