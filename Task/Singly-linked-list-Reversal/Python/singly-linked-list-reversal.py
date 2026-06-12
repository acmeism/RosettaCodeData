class Node:
    def __init__(self, val: int):
        self.next = None
        self.val = val


def reverse(head: Node):
    prev = None
    next_ = None
    cur = head

    while cur is not None:
        next_ = cur.next
        cur.next = prev
        prev = cur
        cur = next_

    return prev


def print_linked_list(head: Node):
    while head is not None:
        print(head.val, end=" ")
        head = head.next

    print()


def main():
    head = tmp = None

    for i in range(6):
        if tmp is None:
            head = tmp = Node(i)
        else:
            tmp.next = tmp = Node(i)

    print_linked_list(head)
    print_linked_list(reverse(head))


if __name__ == "__main__":
    main()
