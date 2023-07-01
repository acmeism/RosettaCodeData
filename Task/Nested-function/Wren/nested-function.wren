var makeList = Fn.new { |sep|
    var counter = 0
    var makeItem = Fn.new { |name|
        counter = counter + 1
        return "%(counter)%(sep)%(name)"
    }
    var items = []
    for (name in ["first", "second", "third"]) {
        items.add(makeItem.call(name))
    }
    System.print(items.join("\n"))
}

makeList.call(". ")
