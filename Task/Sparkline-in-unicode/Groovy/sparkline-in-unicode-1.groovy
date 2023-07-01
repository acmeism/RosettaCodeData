def sparkline(List<Number> list) {
    def (min, max) = [list.min(), list.max()]
    def div = (max - min) / 7
    list.collect { (char)(0x2581 + (it-min) * div) }.join()
}
def sparkline(String text) { sparkline(text.split(/[ ,]+/).collect { it as Double }) }
