class LinkedList(object):
  """USELESS academic/classroom example of a linked list implemented in Python.
     Don't ever consider using something this crude!  Use the built-in list() type!
  """
  def __init__(self, value, next):
    self.value = value;
    self.next = next
  def __iter__(self):
    node = self
    while node != None:
      yield node.value
      node = node.next;

lst = LinkedList("big",  next=
  LinkedList(value="fjords",next=
    LinkedList(value="vex",   next=
      LinkedList(value="quick", next=
        LinkedList(value="waltz", next=
          LinkedList(value="nymph", next=None))))));

for value in lst:
  print value,;
print
