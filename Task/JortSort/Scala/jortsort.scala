import java.util.Objects.deepEquals

def jortSort[K:Ordering]( a:Array[K] ) = deepEquals(a.sorted, a)
