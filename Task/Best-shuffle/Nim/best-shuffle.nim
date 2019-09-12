import times
import sequtils
import strutils
import random

proc count(s1, s2: string): int =
    for i, c in s1:
        if c == s2[i]:
            result.inc

proc shuffle(str: string): string =
    var r = initRand(getTime().toUnix())
    var chrs = toSeq(str.items)
    for i in 0 ..< chrs.len:
        let chosen = r.rand(chrs.len-1)
        swap(chrs[i], chrs[chosen])
    return chrs.join("")

proc bestShuffle(str: string): string =
    var chrs = toSeq(shuffle(str).items)
    for i in chrs.low .. chrs.high:
        if chrs[i] != str[i]:
            continue
        for j in chrs.low .. chrs.high:
            if chrs[i] != chrs[j] and chrs[i] != str[j] and chrs[j] != str[i]:
                swap(chrs[i], chrs[j])
                break
    return chrs.join("")

when isMainModule:
    let words = @["abracadabra", "seesaw", "grrrrrr", "pop", "up", "a", "antidisestablishmentarianism"];
    for w in words:
        let shuffled = bestShuffle(w)
        echo "$1 $2 $3" % [w, shuffled, $count(w, shuffled)]
