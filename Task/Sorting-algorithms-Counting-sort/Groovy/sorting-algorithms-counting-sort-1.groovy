def countingSort = { array ->
    def max = array.max()
    def min = array.min()
    // this list size allows use of Groovy's natural negative indexing
    def count = [0] * (max + 1 + [0, -min].max())
    array.each { count[it] ++ }
    (min..max).findAll{ count[it] }.collect{ [it]*count[it] }.flatten()
}
