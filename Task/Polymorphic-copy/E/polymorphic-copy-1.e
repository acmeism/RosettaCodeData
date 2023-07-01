def deSubgraphKit := <elib:serial.deSubgraphKit>

def copy(object) {
    return deSubgraphKit.recognize(object, deSubgraphKit.makeBuilder())
}
