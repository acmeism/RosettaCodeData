import "io" for File, Directory
import "/srandom" for SRandom
import "/ioutil" for FileUtil, Input
import "/dynamic" for Enum
import "/str" for Char, Str

var CHARS_PER_LINE = 48
var CHUNK_SIZE = 6
var COLS = 8
var DEMO = true  // would normally be set to false

var FileType = Enum.create("FileType", ["OTP", "ENC", "DEC"])

var toAlpha = Fn.new { |s| s.where { |c| Char.isAsciiUpper(c) }.join() }

var isOtpRelated = Fn.new { |s|
    return s.endsWith(".1tp") || s.endsWith(".1tp_cpy") ||
           s.endsWith(".1tp_enc") || s.endsWith(".1tp_dec")
}

var inChunks = Fn.new { |s, nLines, ft|
    var chunks = Str.chunks(s, CHUNK_SIZE)
    var sb = ""
    for (i in 0...nLines) {
        var j = i * COLS
        var ch = chunks[j...j+COLS].join(" ")
        sb = sb + " " + ch + "\n"
    }
    sb = " file\n" + sb
    return (ft == FileType.OTP) ? "# OTP" + sb :
           (ft == FileType.ENC) ? "# Encrypted" + sb :
           (ft == FileType.DEC) ? "# Decrypted" + sb : ""
}

var makePad = Fn.new { |nLines|
    var nChars = nLines * CHARS_PER_LINE
    var sb = ""
    /* generate random upper case letters */
    for (i in 0...nChars) sb = sb + String.fromByte(SRandom.int(65, 91))
    return inChunks.call(sb, nLines, FileType.OTP)
}

var vigenere = Fn.new { |text, key, encrypt|
    var sb = ""
    var i = 0
    for (c in text) {
        var ci = encrypt ? (c.bytes[0] + key[i].bytes[0] - 130) % 26 :
                           (c.bytes[0] - key[i].bytes[0] +  26) % 26
        sb = sb + String.fromByte(ci + 65)
        i = i + 1
    }
    var temp = sb.count % CHARS_PER_LINE
    if (temp > 0) {  // pad with random characters so each line is a full one
        for (i in temp...CHARS_PER_LINE) sb = sb + String.fromByte(SRandom.int(65, 91))
    }
    var ft = encrypt ? FileType.ENC : FileType.DEC
    return inChunks.call(sb, (sb.count / CHARS_PER_LINE).floor, ft)
}

var menu = Fn.new {
    System.print("""

1. Create one time pad file.

2. Delete one time pad file.

3. List one time pad files.

4. Encrypt plain text.

5. Decrypt cipher text.

6. Quit program.

""")
    return Input.integer("Your choice (1 to 6) : ", 1, 6)
}

while (true) {
    var choice = menu.call()
    System.print()
    if (choice == 1) {  // Create OTP
        System.print("Note that encrypted lines always contain 48 characters.\n")
        var fileName = Input.text("OTP file name to create (without extension) : ", 1) + ".1tp"
        var nLines = Input.integer("Number of lines in OTP (max 1000) : ", 1, 1000)
        var key = makePad.call(nLines)
        File.create(fileName) { |f| f.writeBytes(key) }
        System.print("\n'%(fileName)' has been created in the current directory.")
        if (DEMO) {
            // a copy of the OTP file would normally be on a different machine
            var fileName2 = fileName + "_cpy"  // copy for decryption
            File.create(fileName2) { |f| f.writeBytes(key) }
            System.print("'%(fileName2)' has been created in the current directory.")
            System.print("\nThe contents of these files are :\n")
            System.print(key)
        }
    } else if (choice == 2) {  // Delete OTP
        System.print("Note that this will also delete ALL associated files.\n")
        var toDelete1 = Input.text("OTP file name to delete (without extension) : ", 1) + ".1tp"
        var toDelete2 = toDelete1 + "_cpy"
        var toDelete3 = toDelete1 + "_enc"
        var toDelete4 = toDelete1 + "_dec"
        var allToDelete = [toDelete1, toDelete2, toDelete3, toDelete4]
        var deleted = 0
        System.print()
        for (name in allToDelete) {
            if (File.exists(name)) {
                File.delete(name)
                deleted = deleted + 1
                System.print("'%(name)' has been deleted from the current directory.")
            }
        }
        if (deleted == 0) System.print("There are no files to delete.")
    } else if (choice == 3) {  // List OTPs
        System.print("The OTP (and related) files in the current directory are:\n")
        var otpFiles = Directory.list("./").where { |f| File.exists(f) && isOtpRelated.call(f) }.toList
        System.print(otpFiles.join("\n")) // already sorted
    } else if (choice == 4) {  // Encrypt
        var keyFile = Input.text("OTP file name to use (without extension) : ", 1) + ".1tp"
        if (File.exists(keyFile)) {
            var lines = FileUtil.readLines(keyFile)
            var first = lines.count
            for (i in 0...lines.count) {
                if (lines[i].startsWith(" ")) {
                    first = i
                    break
                }
            }
            if (first == lines.count) {
                System.print("\nThat file has no unused lines.")
                continue
            }
            var lines2 = lines.skip(first).toList  // get rid of comments and used lines
            var text = toAlpha.call(Str.upper(Input.text("Text to encrypt :-\n\n", 1)))
            var len = text.count
            var nLines = (len / CHARS_PER_LINE).floor
            if (len % CHARS_PER_LINE > 0) nLines = nLines + 1
            if (lines2.count >= nLines) {
                var key = toAlpha.call(lines2.take(nLines).join(""))
                var encrypted = vigenere.call(text, key, true)
                var encFile = keyFile + "_enc"
                File.create(encFile) { |f| f.writeBytes(encrypted) }
                System.print("\n'%(encFile)' has been created in the current directory.")
                for (i in first...first + nLines) {
                    lines[i] = "-" + lines[i][1..-1]
                }
                File.create(keyFile) { |f| f.writeBytes(lines.join("\n")) }
                if (DEMO) {
                    System.print("\nThe contents of the encrypted file are :\n")
                    System.print(encrypted)
                }
            } else System.print("Not enough lines left in that file to do encryption")
        } else System.print("\nhat file does not exist.")
    } else if (choice == 5) {  // Decrypt
        var keyFile = Input.text("OTP file name to use (without extension) : ", 1) + ".1tp_cpy"
        if (File.exists(keyFile)) {
            var keyLines = FileUtil.readLines(keyFile)
            var first = keyLines.count
            for (i in 0...keyLines.count) {
                if (keyLines[i].startsWith(" ")) {
                    first = i
                    break
                }
            }
            if (first == keyLines.count) {
                System.print("\nThat file has no unused lines.")
                continue
            }
            var keyLines2 = keyLines[first..-1]  // get rid of comments and used lines
            var encFile = keyFile[0..-4] + "enc"
            if (File.exists(encFile)) {
                var encLines = FileUtil.readLines(encFile)[1..-1]  // exclude comment line
                var nLines = encLines.count
                if (keyLines2.count >= nLines) {
                    var encrypted = toAlpha.call(encLines.join(""))
                    var key = toAlpha.call(keyLines2.take(nLines).join(""))
                    var decrypted = vigenere.call(encrypted, key, false)
                    var decFile = keyFile[0..-4] + "dec"
                    File.create(decFile) { |f| f.writeBytes(decrypted) }
                    System.print("\n'%(decFile)' has been created in the current directory.")
                    for (i in first...first + nLines) {
                        keyLines[i] = "-" + keyLines[i][1..-1]
                    }
                    File.create(keyFile) { |f| f.writeBytes(keyLines.join("\n")) }
                    if (DEMO) {
                        System.print("\nThe contents of the decrypted file are :\n")
                        System.print(decrypted)
                    }
                } else System.print("Not enough lines left in that file to do decryption")
            } else System.print("\n'%(encFile)' is missing.")
        } else System.print("\nThat file does not exist.")
    } else {
        return  // Quit
    }
}
