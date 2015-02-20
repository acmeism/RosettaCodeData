import groovy.transform.*

@Canonical
@Sortable(includes = ['freq', 'letter'])
class Node {
    String letter
    int freq
    Node left
    Node right
    boolean isLeaf() { left == null && right == null }
}

Map correspondance(Node n, Map corresp = [:], String prefix = '') {
    if (n.isLeaf()) {
        corresp[n.letter] = prefix ?: '0'
    } else {
        correspondance(n.left,  corresp, prefix + '0')
        correspondance(n.right, corresp, prefix + '1')
    }
    return corresp
}

Map huffmanCode(String message) {
    def queue = message.toList().countBy { it } // char frequencies
        .collect { String letter, int freq ->   // transformed into tree nodes
            new Node(letter, freq)
        } as TreeSet // put in a queue that maintains ordering

    while(queue.size() > 1) {
        def (nodeLeft, nodeRight)  = [queue.pollFirst(), queue.pollFirst()]

        queue << new Node(
            freq:   nodeLeft.freq   + nodeRight.freq,
            letter: nodeLeft.letter + nodeRight.letter,
            left: nodeLeft, right: nodeRight
        )
    }

    return correspondance(queue.pollFirst())
}

String encode(CharSequence msg, Map codeTable) {
    msg.collect { codeTable[it] }.join()
}

String decode(String codedMsg, Map codeTable, String decoded = '') {
    def pair = codeTable.find { k, v -> codedMsg.startsWith(v) }
    pair ? pair.key + decode(codedMsg.substring(pair.value.size()), codeTable)
         : decoded
}
