var nameTable := null
def nameOf(arg :int, ejector) {
    if (nameTable == null) {
        nameTable := <import:nameTableParser>.parseFile(<file:nameTable.txt>)
    }
    if (nameTable.maps(arg)) {
        return nameTable[arg]
    } else {
        ejector(makeNotFoundException("Who?"))
    }
}
