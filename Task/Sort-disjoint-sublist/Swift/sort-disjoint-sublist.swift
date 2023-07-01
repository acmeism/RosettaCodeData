struct DisjointSublistView<T> : MutableCollectionType {
  let array : UnsafeMutablePointer<T>
  let indexes : [Int]

  subscript (position: Int) -> T {
    get {
      return array[indexes[position]]
    }
    set {
      array[indexes[position]] = newValue
    }
  }
  var startIndex : Int { return 0 }
  var endIndex : Int { return indexes.count }
  func generate() -> IndexingGenerator<DisjointSublistView<T>> { return IndexingGenerator(self) }
}

func sortDisjointSublist<T : Comparable>(inout array: [T], indexes: [Int]) {
  var d = DisjointSublistView(array: &array, indexes: sorted(indexes))
  sort(&d)
}

var a = [7, 6, 5, 4, 3, 2, 1, 0]
let ind = [6, 1, 7]
sortDisjointSublist(&a, ind)
println(a)
