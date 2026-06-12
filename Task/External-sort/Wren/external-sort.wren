import "io" for File
import "random" for Random
import "./dynamic" for Struct
import "./sort" for Sort
import "./str" for Str

var MinHeapNode = Struct.create("MinHeapNode", ["element", "index"])

class MinHeap {
    construct new(nodes) {
        _nodes = nodes
        var start = ((_nodes.count-1)/2).floor
        for (i in start..0) minHeapify(i)
    }

    left(i)  { 2*i + 1 }
    right(i) { 2*i + 2 }

    nodes { _nodes }

    min { _nodes[0] }

    replaceMin(x) {
        _nodes[0] = x
        minHeapify(0)
    }

    minHeapify(i) {
        var l = left(i)
        var r = right(i)
        var smallest = i
        var heapSize = _nodes.count
        if (l < heapSize && Str.lt(_nodes[l].element, _nodes[i].element)) smallest = l
        if (r < heapSize && Str.lt(_nodes[r].element, _nodes[smallest].element)) smallest = r
        if (smallest != i) {
            _nodes.swap(i, smallest)
            minHeapify(smallest)
        }
    }
}

// Merge k sorted files: es0,es1 etc.
var mergeFiles = Fn.new { |outputFile, k, e|
    var inp = List.filled(k, null)
    var offset = List.filled(k, 0) // current offset for each input file
    for (i in 0...k) {
        var fileName = "es%(i)"
        inp[i] = File.open(fileName)
    }
    var out = File.create(outputFile)
    var nodes = List.filled(k, null)
    for (i in 0...k) nodes[i] = MinHeapNode.new(0, 0)
    var i = 0
    while (i < k) {
        var bytes = inp[i].readBytes(e)
        if (bytes.count < e) break  // end of file reached
        nodes[i].element = bytes
        nodes[i].index = i
        offset[i] = offset[i] + e
        i = i + 1
    }
    var hp = MinHeap.new(nodes[0...i])
    var count = 0
    while (count != i) {
        var root = hp.min
        out.writeBytes(root.element)
        var bytes = inp[root.index].readBytes(e, offset[root.index])
        if (bytes.count < e) {  // end of file reached
            root.element = "999999 "
            count = count + 1
        } else {
            root.element = bytes
            offset[root.index] = offset[root.index] + e
        }
        hp.replaceMin(root)
    }
    for (j in 0...k) inp[j].close()
    out.close()
}

// Create initial runs, divide them evenly amongst the output files
// and then merge-sort them.
var createInitialRuns = Fn.new { |inputFile, numWays, runSize, elementSize|
    var inp = File.open(inputFile)
    var offset = 0
    for (i in 0...numWays) {
        var fileName = "es%(i)"  // es0, es1 etc.
        var bytes = inp.readBytes(runSize * elementSize, offset)
        offset = offset + runSize * elementSize
        var numbers = Str.chunks(bytes, elementSize)
        numbers = Sort.merge(numbers)
        File.create(fileName) { |f| f.writeBytes(numbers.join("")) }
    }
    inp.close()
}

var externalSort = Fn.new { |inputFile, outputFile, numWays, runSize, elementSize|
    createInitialRuns.call(inputFile, numWays, runSize, elementSize)
    mergeFiles.call(outputFile, numWays, elementSize)
}

// Create a small test file of 40 random 6 digit integers and split it into 4 files
// of 10 such integers each.
var numWays = 4
var runSize = 10
var elementSize = 7  // 6 digits + a following space
var inputFile = "external_sort_input.txt"
var outputFile = "external_sort_output.txt"
var inp = File.create(inputFile)
var rand = Random.new()
var min = 100000
var max = 999999
for (i in 0...numWays*runSize) inp.writeBytes("%(rand.int(min, max).toString) ")
inp.close()
externalSort.call(inputFile, outputFile, numWays, runSize, elementSize)
// remove temporary files
for (i in 0...numWays) {
    var fileName = "es%(i)"
    File.delete(fileName)
}
