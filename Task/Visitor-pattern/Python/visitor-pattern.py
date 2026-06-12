"""An example of the visitor pattern using structural pattern matching.

Requires Python >= 3.10.
"""
from __future__ import annotations

from abc import ABC
from abc import abstractmethod


class CarElement(ABC):
    def accept(self, visitor: CarElementVisitor) -> None:
        visitor.visit(self)


class CarElementVisitor(ABC):
    @abstractmethod
    def visit(self, car_element: CarElement) -> None:
        """Override this in `CarElementVisitor` subclasses."""


class Body(CarElement):
    """Car body."""


class Engine(CarElement):
    """Car engine."""


class Wheel(CarElement):
    """Car wheel"""

    def __init__(self, name: str) -> None:
        self.name = name


class Car(CarElement):
    def __init__(self) -> None:
        self.elements: list[CarElement] = [
            Wheel("front left"),
            Wheel("front right"),
            Wheel("back left"),
            Wheel("back right"),
            Body(),
            Engine(),
        ]

    def accept(self, visitor: CarElementVisitor) -> None:
        for element in self.elements:
            visitor.visit(element)
        super().accept(visitor)


class CarElementDoVisitor(CarElementVisitor):
    def visit(self, car_element: CarElement) -> None:
        match car_element:
            case Body():
                print("Moving my body.")
            case Car():
                print("Starting my car.")
            case Wheel() as wheel:
                print(f"Kicking my {wheel.name} wheel.")
            case Engine():
                print("Starting my engine.")


class CarElementPrintVisitor(CarElementVisitor):
    def visit(self, car_element: CarElement) -> None:
        match car_element:
            case Body():
                print("Visiting body.")
            case Car():
                print("Visiting car.")
            case Wheel() as wheel:
                print(f"Visiting my {wheel.name} wheel.")
            case Engine():
                print("Visiting my engine.")


if __name__ == "__main__":
    car = Car()
    car.accept(CarElementPrintVisitor())
    car.accept(CarElementDoVisitor())
