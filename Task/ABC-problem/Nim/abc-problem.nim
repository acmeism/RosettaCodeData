import std / strutils

func canMakeWord(blocks: seq[string]; word: string): bool =
    if blocks.len < word.len: return false
    if word.len == 0: return true

    let ch = word[0].toUpperAscii
    for i, pair in blocks:
        if ch in pair and
           (blocks[0..<i] & blocks[i+1..^1]).canMakeWord(word[1..^1]):
            return true

proc main =
    for (blocks, words) in [
        ("BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM".splitWhitespace,
         @["A", "bArK", "BOOK", "treat", "common", "sQuAd", "CONFUSE"]),
        ("AB AB AC AC".splitWhitespace, @["ABBa"]),
        ("US TZ AO QA".splitWhitespace, @["Auto"])
    ]:
        echo "Using the blocks ", blocks.join(" ")
        for word in words:
            echo " can we make the word '$#'? $#" % [
                word, if blocks.canMakeWord(word): "yes" else: "no"]
        echo()

when isMainModule: main()
