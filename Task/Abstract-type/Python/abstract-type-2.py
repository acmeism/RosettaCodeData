from typing import Literal
from typing import Protocol

class Pet(Protocol):
    def speak(self) -> str: ...

class Cat:
    def __init__(self, name: str) -> None:
        self.name = name

    def speak(self) -> str:
        return f"{self.name} says meow"

class Dog:
    def __init__(self, name: str, size: Literal["small", "big"] = "small") -> None:
        self.name = name
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
