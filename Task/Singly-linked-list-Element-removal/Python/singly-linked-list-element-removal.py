class Node:
    def __init__(self, data=None):
        self.data = data
        self.next = None


class SLinkedList:
    def __init__(self):
        self.head = None

    def insert_first(self, insert_this):
        new_node = Node(insert_this)
        new_node.next = self.head
        self.head = new_node

    def remove_node(self, remove_this):

        # declare the "first" in list
        head_val = self.head

        # IF first in list isn't None, then...
        # IF first in list == value to be removed, then...
        # assign the NEXT node as the new "first in list"
        if head_val is not None:
            if head_val.data == remove_this:
                self.head = head_val.next
                return

        # WHILE first in list is not None, then...
        # IF first in list == value to be removed, then...
        # BREAK
        # ELSE assign current first in list in "prev" (to preserve it's value) , and...
        # assign next value as first in list
        while head_val is not None:
            if head_val.data == remove_this:
                break
            prev = head_val
            head_val = head_val.next

        # if first in list is empty, exit function
        if head_val is None:
            return

        # this assignment removes the value to be deleted
        prev.next = head_val.next

    def print_llist(self):
        print_node = self.head
        while print_node:
            print(print_node.data),
            print_node = print_node.next

mylist = SLinkedList()
mylist.insert_first("red")
mylist.insert_first("orange")
mylist.insert_first("yellow")
mylist.insert_first("green")
print("Original list:")
mylist.print_llist()
mylist.remove_node("orange")
print("\nAfter orange is removed:")
mylist.print_llist()

