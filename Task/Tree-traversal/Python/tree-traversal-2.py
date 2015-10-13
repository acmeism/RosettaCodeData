from collections import namedtuple
from sys import stdout

class Node(namedtuple('Node', 'data, left, right')):
    __slots__ = ()

    def preorder(self, visitor):
        if self is not None:
            visitor(self.data)
            Node.preorder(self.left, visitor)
            Node.preorder(self.right, visitor)

    def inorder(self, visitor):
        if self is not None:
            Node.inorder(self.left, visitor)
            visitor(self.data)
            Node.inorder(self.right, visitor)

    def postorder(self, visitor):
        if self is not None:
            Node.postorder(self.left, visitor)
            Node.postorder(self.right, visitor)
            visitor(self.data)

    def levelorder(self, visitor, more=None):
        if self is not None:
            if more is None:
                more = []
            more += [self.left, self.right]
            visitor(self.data)
        if more:
            Node.levelorder(more[0], visitor, more[1:])


def printwithspace(i):
    stdout.write("%i " % i)


tree = Node(1,
            Node(2,
                 Node(4,
                      Node(7, None, None),
                      None),
                 Node(5, None, None)),
            Node(3,
                 Node(6,
                      Node(8, None, None),
                      Node(9, None, None)),
                 None))


if __name__ == '__main__':
    stdout.write('  preorder: ')
    tree.preorder(printwithspace)
    stdout.write('\n   inorder: ')
    tree.inorder(printwithspace)
    stdout.write('\n postorder: ')
    tree.postorder(printwithspace)
    stdout.write('\nlevelorder: ')
    tree.levelorder(printwithspace)
    stdout.write('\n')
