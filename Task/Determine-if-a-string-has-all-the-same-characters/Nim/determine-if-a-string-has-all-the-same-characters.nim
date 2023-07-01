import strformat

proc analyze(str: string) =
    if str.len() > 1:
        var first = str[0]
        for i, c in str:
            if c != first:
                echo "'", str, "': [len: ", str.len(), "] not all characters are the same. starts to differ at index ",
                    i, ": '", first, "' != '", c, "' [", fmt"{ord(c):#x}", "]"
                return
    echo "'", str, "': [len: ", str.len(), "] all characters are the same"

var strings = @["", "   ", "2", "333", ".55", "tttTTT", "4444 444k"]
for str in strings:
    analyze(str)
