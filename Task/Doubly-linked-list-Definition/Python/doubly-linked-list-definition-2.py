"""A doubly-linked list. Requires Python >=3.7"""
from __future__ import annotations

import math

from abc import ABC

from collections.abc import MutableSequence
from collections.abc import Sequence
from dataclasses import dataclass
from dataclasses import field

from typing import Any
from typing import Iterable
from typing import Iterator
from typing import Optional
from typing import Union


@dataclass
class Node:
    value: Any
    prev: Optional[Node] = field(default=None)
    next: Optional[Node] = field(default=None)


class BaseDoublyLinkedList(ABC):
    def __len__(self):
        return self.size

    def __iter__(self) -> Iterator[Any]:
        node = self.head
        cnt = 1
        while node is not None and cnt <= self.size:
            yield node.value
            node = node.next
            cnt += 1

    def __reversed__(self) -> Iterator[Any]:
        node = self.tail
        while node is not None:
            yield node.value
            node = node.prev

    def __getitem__(self, key: Union[int, slice]) -> Optional[Any]:
        if isinstance(key, int):
            node = self._find_node(key)
            return node.value

        if key.step not in (None, 1):
            raise IndexError("can't step more than 1")

        start = key.start or 0
        node = self._find_node(start)
        return DoublyLinkedListView(node, key.stop - start - 1)

    def _find_node(self, index) -> Node:
        if index > self.size - 1 or index < -self.size:
            raise IndexError("list index out of range")

        if index >= 0:
            node = self.head
            for _ in range(index):
                node = node.next
        else:
            node = self.tail
            for _ in range(self.size - 1, self.size - abs(index), -1):
                node = node.prev

        return node


class DoublyLinkedListView(BaseDoublyLinkedList, Sequence):
    def __init__(self, node, stop=math.inf):
        self.head = node

        # Find the tail
        cnt = 1
        while node is not None and cnt <= stop:
            node = node.next
            cnt += 1

        self.tail = node
        self.size = cnt

    def __repr__(self):
        return f"DoublyLinkedListView([{', '.join(repr(v) for v in self)}])"

    def __str__(self):
        return repr(self)


class DoublyLinkedList(BaseDoublyLinkedList, MutableSequence):
    def __init__(self, iterable: Iterable):
        it = iter(iterable)

        # Possibly empty iterable
        try:
            self.head = Node(value=next(it))
            self.tail = self.head
            self.size = 1
        except StopIteration:
            self.head = None
            self.tail = None
            self.size = 0

        node = self.head

        for val in it:
            self.tail = Node(value=val, prev=node)
            node.next = self.tail
            node = self.tail
            self.size += 1

    def __repr__(self):
        return f"DoublyLinkedList([{', '.join(repr(v) for v in self)}])"

    def __str__(self):
        return repr(self)

    def __setitem__(self, key, value):
        node = self._find_node(key)
        node.value = value

    def __delitem__(self, key) -> None:
        node = self._find_node(key)
        node.prev.next = node.next
        node.next.prev = node.prev
        self.size -= 1

    def insert(self, index: int, value: Any) -> None:
        node = self._find_node(index)
        new_node = Node(value=value, prev=node.prev, next=node)

        node.prev.next = new_node
        node.prev = node

        self.size += 1

    def append(self, value: Any) -> None:
        tail = self.tail
        node = Node(value=value, prev=tail)
        tail.next = node

        self.tail = node
        self.size += 1

    def appendleft(self, value: Any) -> None:
        head = self.head
        node = Node(value=value, next=head)
        head.prev = node

        self.head = node
        self.size += 1

    def pop(self) -> Any:
        value = self.tail.value
        self.tail = self.tail.prev
        self.tail.next = None
        self.size -= 1
        return value

    def popleft(self) -> Any:
        value = self.head.value
        self.head = self.head.next
        self.head.prev = None
        self.size -= 1
        return value
