from collections import namedtuple

Node = namedtuple('Node', 'data, left, right')
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

def printwithspace(i):
    print(i, end=' ')

def dfs(order, node, visitor):
    if node is not None:
        for action in order:
            if action == 'N':
                visitor(node.data)
            elif action == 'L':
                dfs(order, node.left, visitor)
            elif action == 'R':
                dfs(order, node.right, visitor)

def preorder(node, visitor = printwithspace):
    dfs('NLR', node, visitor)

def inorder(node, visitor = printwithspace):
    dfs('LNR', node, visitor)

def postorder(node, visitor = printwithspace):
    dfs('LRN', node, visitor)

def ls(node, more, visitor, order='TB'):
    "Level-based Top-to-Bottom or Bottom-to-Top tree search"
    if node:
        if more is None:
            more = []
        more += [node.left, node.right]
    for action in order:
        if action == 'B' and more:
            ls(more[0], more[1:], visitor, order)
        elif action == 'T' and node:
            visitor(node.data)

def levelorder(node, more=None, visitor = printwithspace):
    ls(node, more, visitor, 'TB')

# Because we can
def reverse_preorder(node, visitor = printwithspace):
    dfs('RLN', node, visitor)

def bottom_up_order(node, more=None, visitor = printwithspace, order='BT'):
    ls(node, more, visitor, 'BT')


if __name__ == '__main__':
    w = 10
    for traversal in [preorder, inorder, postorder, levelorder,
                      reverse_preorder, bottom_up_order]:
        if traversal == reverse_preorder:
            w = 20
            print('\nThe generalisation of function dfs allows:')
        if traversal == bottom_up_order:
            print('The generalisation of function ls allows:')
        print(f"{traversal.__name__:>{w}}:", end=' ')
        traversal(tree)
        print()
