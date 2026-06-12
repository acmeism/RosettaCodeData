class Node:
    def __init__(self, val, prev, next_node = None):
        self.val = val
        self.prev = prev
        self.next_node = next_node

    def __repr__(self):
        return f'Node({self.val})'

class DoublyLinkedList:
    def __init__(self):
        self.head = None
        self.tail = None

    def append(self, val):
        if self.head is None:
            self.head = self.tail = Node(val, None)
        else:
            self.tail.next_node = self.tail = Node(val, self.tail)

    def remove(self, val):
        tmp = self.head

        while tmp:
            if tmp.val == val:
                break

            tmp = tmp.next_node

        if tmp is None:
            return

        if tmp is self.head:
            self.head = self.head.next_node

            if self.head is not None:
                self.head.prev = None

        else:
            prev = tmp.prev
            next_node = tmp.next_node
            prev.next_node = next_node

            if next_node:
                next_node.prev = prev

    def __repr__(self):
        strings = []
        tmp = self.head

        while tmp:
            strings.append(str(tmp.val))
            tmp = tmp.next_node

        string = ','.join(strings)

        return f'[{string}]'

def main():
    lst = DoublyLinkedList()

    for string in ['First', 'Second', 'Third', 'Fourth', 'Fifth']:
        lst.append(string)

    rm_strings = ['Second', 'Fourth', 'First', 'Fifth', 'Third']

    for rm in rm_strings:
        print('Remove:', rm)
        lst.remove(rm)
        print(lst)

if __name__ == '__main__':
    main()
