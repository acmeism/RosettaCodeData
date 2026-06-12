"""Brace expansion using ranges. Requires Python >= 3.6.

Here we use regular expressions for parsing and take an object orientated approach
to expansion of range expressions.

This implementation supports stepped ordinal range expressions.
"""

from __future__ import annotations

import itertools
import re

from abc import ABC
from abc import abstractmethod

from typing import Iterable
from typing import Optional


RE_SPEC = [
    (
        "INT_RANGE",
        r"\{(?P<int_start>[0-9]+)..(?P<int_stop>[0-9]+)(?:(?:..)?(?P<int_step>-?[0-9]+))?}",
    ),
    (
        "ORD_RANGE",
        r"\{(?P<ord_start>[^0-9])..(?P<ord_stop>[^0-9])(?:(?:..)?(?P<ord_step>-?[0-9]+))?}",
    ),
    (
        "LITERAL",
        r".+?(?=\{|$)",
    ),
]


RE_EXPRESSION = re.compile(
    "|".join(rf"(?P<{name}>{pattern})" for name, pattern in RE_SPEC)
)


class Expression(ABC):
    """Brace expression abstract base class."""

    @abstractmethod
    def expand(self, prefix: str) -> Iterable[str]:
        pass


class Literal(Expression):
    """An expression literal."""

    def __init__(self, value: str):
        self.value = value

    def expand(self, prefix: str) -> Iterable[str]:
        return [f"{prefix}{self.value}"]


class IntRange(Expression):
    """An integer range expression."""

    def __init__(
        self, start: int, stop: int, step: Optional[int] = None, zfill: int = 0
    ):
        self.start, self.stop, self.step = fix_range(start, stop, step)
        self.zfill = zfill

    def expand(self, prefix: str) -> Iterable[str]:
        return (
            f"{prefix}{str(i).zfill(self.zfill)}"
            for i in range(self.start, self.stop, self.step)
        )


class OrdRange(Expression):
    """An ordinal range expression."""

    def __init__(self, start: str, stop: str, step: Optional[int] = None):
        self.start, self.stop, self.step = fix_range(ord(start), ord(stop), step)

    def expand(self, prefix: str) -> Iterable[str]:
        return (f"{prefix}{chr(i)}" for i in range(self.start, self.stop, self.step))


def expand(expressions: Iterable[Expression]) -> Iterable[str]:
    """Expand a sequence of ``Expression``s. Each expression builds on the results
    of the expressions that come before it in the sequence."""
    expanded = [""]

    for expression in expressions:
        expanded = itertools.chain.from_iterable(
            [expression.expand(prefix) for prefix in expanded]
        )

    return expanded


def zero_fill(start, stop) -> int:
    """Return the target zero padding width."""

    def _zfill(s):
        if len(s) <= 1 or not s.startswith("0"):
            return 0
        return len(s)

    return max(_zfill(start), _zfill(stop))


def fix_range(start, stop, step):
    """Transform start, stop and step so that we can pass them to Python's
    built-in ``range`` function."""
    if not step:
        # Zero or None. Explicit zero gets changed to default.
        if start <= stop:
            # Default step for ascending ranges.
            step = 1
        else:
            # Default step for descending ranges.
            step = -1

    elif step < 0:
        # A negative step means we reverse the range.
        start, stop = stop, start

        if start < stop:
            step = abs(step)
        else:
            start -= 1
            stop -= 1

    elif start > stop:
        # A descending range with explicit step.
        step = -step

    # Don't overshoot or fall short.
    if (start - stop) % step == 0:
        stop += step

    return start, stop, step


def parse(expression: str) -> Iterable[Expression]:
    """Generate a sequence of ``Expression``s from the given range expression."""
    for match in RE_EXPRESSION.finditer(expression):
        kind = match.lastgroup

        if kind == "INT_RANGE":
            start = match.group("int_start")
            stop = match.group("int_stop")
            step = match.group("int_step")
            zfill = zero_fill(start, stop)

            if step is not None:
                step = int(step)

            yield IntRange(int(start), int(stop), step, zfill=zfill)

        elif kind == "ORD_RANGE":
            start = match.group("ord_start")
            stop = match.group("ord_stop")
            step = match.group("ord_step")

            if step is not None:
                step = int(step)

            yield OrdRange(start, stop, step)

        elif kind == "LITERAL":
            yield Literal(match.group())


def examples():
    cases = [
        r"simpleNumberRising{1..3}.txt",
        r"simpleAlphaDescending-{Z..X}.txt",
        r"steppedDownAndPadded-{10..00..5}.txt",
        r"minusSignFlipsSequence {030..20..-5}.txt",
        r"reverseSteppedNumberRising{1..6..-2}.txt",
        r"combined-{Q..P}{2..1}.txt",
        r"emoji{🌵..🌶}{🌽..🌾}etc",
        r"li{teral",
        r"rangeless{}empty",
        r"rangeless{random}string",
        # Extra examples, not from the task description.
        r"steppedNumberRising{1..6..2}.txt",
        r"steppedNumberDescending{20..9..2}.txt",
        r"steppedAlphaDescending-{Z..M..2}.txt",
        r"reverseSteppedAlphaRising{A..F..-2}.txt",
        r"reversedSteppedAlphaDescending-{Z..M..-2}.txt",
    ]

    for case in cases:
        print(f"{case} ->")
        expressions = parse(case)

        for itm in expand(expressions):
            print(f"{' '*4}{itm}")

        print("")  # Blank line between cases


if __name__ == "__main__":
    examples()
