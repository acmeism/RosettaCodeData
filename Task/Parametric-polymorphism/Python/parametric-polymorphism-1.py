"""Parametric polymorphism. Requires Python >= 3.9."""

from typing import Callable
from typing import Generic
from typing import Iterable
from typing import TypeVar
from typing import Union

T = TypeVar("T")


class Tree(Generic[T]):
    def __init__(self, value: T):
        self.value = value
        self.left: Union[Tree[T], None] = None
        self.right: Union[Tree[T], None] = None

    def map(self, func: Callable[[T], T]) -> Iterable[T]:
        yield func(self.value)
        if self.left is not None:
            yield from self.left.map(func)
        if self.right is not None:
            yield from self.right.map(func)


if __name__ == "__main__":
    tree = Tree(7)
    tree.left = Tree(42)
    tree.right = Tree(101)
    tree.right.left = Tree(1)

    # Fails static type checking as "foo" is not an int.
    # tree.left.left = Tree[int]("foo")

    # Fails static type checking as Tree[str] is not Tree[int]
    # tree.left.left = Tree("bar")

    print(list(tree.map(lambda v: v + 1)))  # [8, 43, 102, 2]
