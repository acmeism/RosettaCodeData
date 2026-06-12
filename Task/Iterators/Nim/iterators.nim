import std/lists

# Days stored in an array.
let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

# Colors stored in a doubly linked list.
let colors = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple"].toDoublyLinkedList


### To print the elements of "days", we use a standard iterator.
echo "Content of “days” array:"
for day in days:
  echo day
echo()


### To print the elements of "colors", we use a standard iterator.
echo "Content of “colors” list:"
for color in colors:
  echo color
echo()


### To print the first, fourth an fifth elements
### of "days", we use a standard iterator.
echo "First, fourth and fifth elements of “days”:"
for i, day in days:
  if i + 1 in [1, 4, 5]:
    echo day
echo()


### To print the first, fourth an fifth elements
### of "colors", we must define our own iterator.

iterator enumerate[T](list: DoublyLinkedList[T]): (int, T) =
  ## Yield the successive (index, value).*
  ## First index is 0.
  var i = 0
  var node = list.head
  while node != nil:
    yield (i, node.value)
    node = node.next
    inc i

echo "First, fourth and fifth elements of “colors”:"
for i, color in colors.enumerate:
  if i + 1 in [1, 4, 5]:
    echo color
echo()


### To print the last, fourth to last, and fifth to last
### elements of "days", we must define our own iterator.

iterator revItems[T](a: openArray[T]): (int, T) =
  ## Starting from end of array, yield (index, value).
  ## First index is 1.
  for i in countdown(a.high, 0):
    yield (a.len - i, a[i])

echo "Last, fourth to last and fifth to last elements of “days”:"
for i, day in days.revItems:
  if i in [1, 4, 5]:
    echo day
echo()


### To print the last, fourth to last, and fifth to last
### elements of "colors", we must define our own iterator.

iterator revItems[T](list: DoublyLinkedList[T]): (int, T) =
  ## Starting from end of the list, yield (index, value).
  ## First index is 1.
  var i = 1
  var node = list.tail
  while node != nil:
    yield (i, node.value)
    node = node.prev
    inc i

echo "Last, fourth to last and fifth to last elements of “colors”:"
for i, color in colors.revItems:
  if i in [1, 4, 5]:
    echo color
