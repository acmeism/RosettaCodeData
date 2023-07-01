from __future__ import annotations
from enum import Enum
from typing import NamedTuple
from typing import Optional


class Color(Enum):
    B = 0
    R = 1


class Tree(NamedTuple):
    color: Color
    left: Optional[Tree]
    value: int
    right: Optional[Tree]

    def insert(self, val: int) -> Tree:
        return self._insert(val).make_black()

    def _insert(self, val: int) -> Tree:
        match compare(val, self.value):
            case _ if self == EMPTY:
                return Tree(Color.R, EMPTY, val, EMPTY)
            case -1:
                assert self.left is not None
                return Tree(
                    self.color, self.left._insert(val), self.value, self.right
                ).balance()
            case 1:
                assert self.right is not None
                return Tree(
                    self.color, self.left, self.value, self.right._insert(val)
                ).balance()
            case _:
                return self

    def balance(self) -> Tree:
        match self:
            case (Color.B, (Color.R, (Color.R, a, x, b), y, c), z, d):
                return Tree(Color.R, Tree(Color.B, a, x, b), y, Tree(Color.B, c, z, d))
            case (Color.B, (Color.R, a, x, (Color.R, b, y, c)), z, d):
                return Tree(Color.R, Tree(Color.B, a, x, b), y, Tree(Color.B, c, z, d))
            case (Color.B, a, x, (Color.R, (Color.R, b, y, c), z, d)):
                return Tree(Color.R, Tree(Color.B, a, x, b), y, Tree(Color.B, c, z, d))
            case (Color.B, a, x, (Color.R, b, y, (Color.R, c, z, d))):
                return Tree(Color.R, Tree(Color.B, a, x, b), y, Tree(Color.B, c, z, d))
            case _:
                return self

    def make_black(self) -> Tree:
        return self._replace(color=Color.B)

    def __str__(self) -> str:
        if self == EMPTY:
            return "[]"
        return f"[{'R' if self.color == Color.R else 'B'}{self.value}]"

    def print(self, indent: int = 0) -> None:
        if self != EMPTY:
            assert self.right is not None
            self.right.print(indent + 1)

        print(f"{' ' * indent * 4}{self}")

        if self != EMPTY:
            assert self.left is not None
            self.left.print(indent + 1)


EMPTY = Tree(Color.B, None, 0, None)


def compare(x: int, y: int) -> int:
    if x > y:
        return 1
    if x < y:
        return -1
    return 0


def main():
    tree = EMPTY
    for i in range(1, 17):
        tree = tree.insert(i)
    tree.print()


if __name__ == "__main__":
    main()
