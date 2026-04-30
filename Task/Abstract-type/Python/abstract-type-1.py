from abc import ABC
from abc import abstractmethod
from typing import Literal

class Pet(ABC):
    def __init__(self, name: str) -> None:
        self.name = name

    @abstractmethod
    def speak(self) -> str: ...

class Cat(Pet):
    def speak(self) -> str:
        return f"{self.name} says meow"

class Dog(Pet):
    def __init__(self, name: str, size: Literal["small", "big"] = "small") -> None:
        super().__init__(name)
        self.size = size

    def speak(self) -> str:
        return "woof" if self.size == "small" else "loud woof"


if __name__ == "__main__":
    pets: list[Pet] = [
        Cat(name="Fluffy"),
        Dog(name="Gary"),
        Dog(name="Sue", size="big"),
    ]

    for pet in pets:
        print(pet.speak())
