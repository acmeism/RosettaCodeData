def clockRealTime = { Closure c ->
    def start = System.currentTimeMillis()
    c.call()
    System.currentTimeMillis() - start
}
