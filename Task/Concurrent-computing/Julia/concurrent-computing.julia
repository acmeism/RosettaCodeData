words = ["Enjoy", "Rosetta", "Code"]

function sleepprint(s)
    sleep(rand())
    println(s)
end

@sync for word in words
    @async sleepprint(word)
end
