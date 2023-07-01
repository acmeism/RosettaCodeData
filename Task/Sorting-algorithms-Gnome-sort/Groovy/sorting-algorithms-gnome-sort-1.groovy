def makeSwap = { a, i, j = i+1 -> print "."; a[[j,i]] = a[[i,j]] }

def checkSwap = { list, i, j = i+1 -> [(list[i] > list[j])].find{ it }.each { makeSwap(list, i, j) } }

def gnomeSort = { input ->
    def swap = checkSwap.curry(input)
    def index = 1
    while (index < input.size()) {
        index += (swap(index-1) && index > 1) ? -1 : 1
    }
    input
}
