"""An approximation of the rendezvous pattern found in Ada using asyncio."""
from __future__ import annotations

import asyncio
import sys

from typing import Optional
from typing import TextIO


class OutOfInkError(Exception):
    """Exception raised when a printer is out of ink."""


class Printer:
    def __init__(self, name: str, backup: Optional[Printer]):
        self.name = name
        self.backup = backup

        self.ink_level: int = 5
        self.output_stream: TextIO = sys.stdout

    async def print(self, msg):
        if self.ink_level <= 0:
            if self.backup:
                await self.backup.print(msg)
            else:
                raise OutOfInkError(self.name)
        else:
            self.ink_level -= 1
            self.output_stream.write(f"({self.name}): {msg}\n")


async def main():
    reserve = Printer("reserve", None)
    main = Printer("main", reserve)

    humpty_lines = [
        "Humpty Dumpty sat on a wall.",
        "Humpty Dumpty had a great fall.",
        "All the king's horses and all the king's men,",
        "Couldn't put Humpty together again.",
    ]

    goose_lines = [
        "Old Mother Goose,",
        "When she wanted to wander,",
        "Would ride through the air,",
        "On a very fine gander.",
        "Jack's mother came in,",
        "And caught the goose soon,",
        "And mounting its back,",
        "Flew up to the moon.",
    ]

    async def print_humpty():
        for line in humpty_lines:
            try:
                task = asyncio.Task(main.print(line))
                await task
            except OutOfInkError:
                print("\t Humpty Dumpty out of ink!")
                break

    async def print_goose():
        for line in goose_lines:
            try:
                task = asyncio.Task(main.print(line))
                await task
            except OutOfInkError:
                print("\t Mother Goose out of ink!")
                break

    await asyncio.gather(print_goose(), print_humpty())


if __name__ == "__main__":
    asyncio.run(main(), debug=True)
