import "/ioutil" for Input

var menu = Fn.new { |list|
    var n = list.count
    if (n == 0) return ""
    var prompt = "\n   M E N U\n\n"
    for (i in 0...n) prompt = prompt + "%(i+1). %(list[i])\n"
    prompt = prompt + "\nEnter your choice (1 - %(n)): "
    var index = Input.integer(prompt, 1, n)
    return list[index-1]
}

var list = ["fee fie", "huff and puff", "mirror mirror", "tick tock"]
var choice = menu.call(list)
System.print("\nYou chose : %(choice)")
