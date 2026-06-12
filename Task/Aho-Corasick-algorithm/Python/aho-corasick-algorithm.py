import sys
from collections import deque
def fast_input():
    return sys.stdin.readline().strip()
class Node:
    def __init__(self):
        self.son = [0] * 26
        self.ans = 0
        self.fail = 0
        self.du = 0
        self.idx = 0
class ACAutomaton:
    def __init__(self, max_nodes):
        self.tr = [Node() for _ in range(max_nodes)]
        self.tr[0] = Node()
        self.tot = 0
        self.final_ans = []
        self.pidx = 0
    def init(self):
        self.tr = [Node() for _ in range(len(self.tr))]
        self.tr[0] = Node()
        self.tot = 0
        self.pidx = 0
        self.final_ans = []
    def insert(self, pattern):
        u = 0
        for char in pattern:
            char_code = ord(char) - ord('a')
            if self.tr[u].son[char_code] == 0:
                self.tot += 1
                self.tr[u].son[char_code] = self.tot
            u = self.tr[u].son[char_code]
        if self.tr[u].idx == 0:
            self.pidx += 1
            self.tr[u].idx = self.pidx
        return self.tr[u].idx
    def build(self):
        q = deque()
        for i in range(26):
            if self.tr[0].son[i] != 0:
                q.append(self.tr[0].son[i])
        while q:
            u = q.popleft()
            for i in range(26):
                son_node_idx = self.tr[u].son[i]
                fail_node_idx = self.tr[u].fail
                if son_node_idx != 0:
                    self.tr[son_node_idx].fail = self.tr[fail_node_idx].son[i]
                    self.tr[self.tr[son_node_idx].fail].du += 1
                    q.append(son_node_idx)
                else:
                    self.tr[u].son[i] = self.tr[fail_node_idx].son[i]
    def query(self, text):
        u = 0
        for char in text:
            char_code = ord(char) - ord('a')
            u = self.tr[u].son[char_code]
            self.tr[u].ans += 1
    def calculate_final_answers(self):
        self.final_ans = [0] * (self.pidx + 1)
        q = deque()
        for i in range(self.tot + 1):
            if self.tr[i].du == 0:
                q.append(i)
        while q:
            u = q.popleft()
            node_idx = self.tr[u].idx
            if node_idx != 0:
                self.final_ans[node_idx] = self.tr[u].ans
            v = self.tr[u].fail
            self.tr[v].ans += self.tr[u].ans
            self.tr[v].du -= 1
            if self.tr[v].du == 0:
                q.append(v)
if __name__ == "__main__":
    MAX_NODES = 200000 + 6
    MAX_N = 200000 + 6
    ac = ACAutomaton(MAX_NODES)
    n = 5
    pattern_end_node_ids = [0] * (n + 1)
    my_input=["a","bb","aa","abaa","abaaa","abaaabaa"]
    text = "abaaabaa"
    for i in range(1, n+1):
        pattern = my_input[i-1]
        pattern_end_node_ids[i] = ac.insert(pattern)
    ac.build()
    ac.query(text)
    ac.calculate_final_answers()
    for i in range(1, n + 1):
        unique_id = pattern_end_node_ids[i]
        print(ac.final_ans[unique_id])
