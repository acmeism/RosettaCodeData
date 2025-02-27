"""Constrained genericity. Requires Python >= 3.9."""

from typing import Generic
from typing import Protocol
from typing import TypeVar
from typing import runtime_checkable

T = TypeVar("T", covariant=True)


@runtime_checkable
class Edible(Protocol[T]):
    def eat(self) -> T: ...


class FoodBox(Generic[T]):
    def __init__(self, *food: Edible[T]):
        # Runtime type checking
        for item in food:
            if not isinstance(item, Edible):
                raise TypeError(f"expected food, found {item.__class__.__name__}")

        self.contents = food


class Cheese:
    def eat(self) -> None:
        print("eating cheese")


class Shoe:
    def wear(self) -> None:
        print("wearing shoe")


if __name__ == "__main__":
    box = FoodBox[None](Cheese())
    for food in box.contents:
        food.eat()

    # This fails static type checking.
    box = FoodBox[None](Cheese(), Shoe())
