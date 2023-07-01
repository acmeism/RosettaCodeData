? if ("<abc,def>" =~ `<@a,@b>`) { [a, b] } else { null }
# value: ["abc", "def"]

? if (" >abc, def< " =~ rx`\W*(@a\w+)\W+(@b\w+)\W*`) { [a, b] } else { null }
# value: ["abc", "def"]
