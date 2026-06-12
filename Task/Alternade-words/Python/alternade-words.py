WORDFILE = 'unixdict.txt'
MINLEN = 6

class Trie(object):
    """Trie data structure"""
    class Node(object):
        """A node in the trie"""
        def __init__(self, char='\0', parent=None):
            self.children = {}
            self.char = char
            self.final = False
            self.parent = parent

        def descend(self, char, extend=False):
            """Descend into the trie"""
            if not char in self.children:
                if not extend: return None
                self.children[char] = Trie.Node(char,self)
            return self.children[char]

    def __init__(self):
        self.root = Trie.Node()

    def insert(self, word):
        """Insert a word in the trie"""
        node = self.root
        for char in word: node = node.descend(char, extend=True)
        node.final = True
        return node

    def __contains__(self, word):
        """See if the trie contains a word"""
        node = self.root
        for char in word:
            node = node.descend(char)
            if not node: return False
        return node.final

    def words(self):
        """Yield every word in the trie"""
        nodes = [self.root]
        while nodes:
            node = nodes.pop()
            nodes += node.children.values()
            if node.final:
                word = []
                while node:
                    if node.char != '\0': word.append(node.char)
                    node = node.parent
                yield "".join(reversed(word))

    def __iter__(self):
        return self.words()


words = Trie()
with open(WORDFILE, "rt") as f:
    for word in f.readlines():
        words.insert(word.strip())

for word in words:
    if len(word) < MINLEN: continue
    even = word[::2]
    odd = word[1::2]
    if even in words and odd in words:
        print(word, even, odd)
