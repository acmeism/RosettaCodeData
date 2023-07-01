def shuffle = { list ->
    if (list == null || list.empty) return list
    def r = new Random()
    def n = list.size()
    (n..1).each { i ->
        def j = r.nextInt(i)
        list[[i-1, j]] = list[[j, i-1]]
    }
    list
}
