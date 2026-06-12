"""Display bytes in a file like hexdump or xxd."""
import abc
import math
from io import BufferedIOBase
from io import SEEK_END
from itertools import islice
from typing import Iterable
from typing import Iterator
from typing import Sequence
from typing import Tuple
from typing import TypeVar


READ_SIZE = 2048


class Formatter(abc.ABC):
    """Base class for hex dump formatters."""

    @abc.abstractmethod
    def format(self, data: Sequence[int]) -> str:
        """Return _data_ formatted for output on one line."""

    @property
    @abc.abstractmethod
    def bytes_per_line(self) -> int:
        """The number of bytes to display per line of output."""


class CanonicalFormatter(Formatter):
    bytes_per_line = 16

    def format(self, data: Sequence[int]) -> str:
        assert len(data) <= 16
        hex = f"{bytes(data[:8]).hex(' ')}  {bytes(data[8:]).hex(' ')}".ljust(48)
        ascii_ = "".join(chr(b) if b > 31 and b < 127 else "." for b in data)
        return f"{hex}  |{ascii_}|"


class BinaryFormatter(Formatter):
    bytes_per_line = 6

    def format(self, data: Sequence[int]) -> str:
        assert len(data) <= 6
        bits = " ".join(bin(b)[2:].rjust(8, "0") for b in data).ljust(53)
        ascii_ = "".join(chr(b) if b > 31 and b < 127 else "." for b in data)
        return f"{bits}  |{ascii_}|"


canonicalFormatter = CanonicalFormatter()
binaryFormatter = BinaryFormatter()

T = TypeVar("T")


def group(it: Iterable[T], n: int) -> Iterator[Tuple[T, ...]]:
    """Split iterable _it_ in to groups of size _n_.

    The last group might contain less than _n_ items.
    """
    _it = iter(it)
    while True:
        g = tuple(islice(_it, n))
        if not g:
            break
        yield g


def hex_dump(
    f: BufferedIOBase,
    *,
    skip: int = 0,
    length: int = math.inf,  # type: ignore
    formatter: Formatter = canonicalFormatter,
) -> Iterator[str]:
    """Generate a textual representation of bytes in _f_, one line at a time."""
    f.seek(skip)
    offset = skip
    byte_count = 0
    previous_line = ""
    squeezing = False  # True if the last output line was squeezed

    assert length > 0

    while byte_count < length:
        # Read at most READ_SIZE bytes at a time.
        data = f.read(READ_SIZE)

        # Stop if we've run out of data.
        if not data:
            break

        # Discard excess bytes if we've overshot length.
        if byte_count + len(data) > length:
            data = data[: length - byte_count]

        # One line per chunk
        for chunk in group(data, formatter.bytes_per_line):
            line = formatter.format(chunk)
            if previous_line == line:
                if squeezing is False:
                    squeezing = True
                    yield "*"
            else:
                previous_line = line
                squeezing = False
                yield f"{offset:0>8x}  {line}"

            offset += formatter.bytes_per_line
            byte_count += len(chunk)

    # Final byte count
    bytes_in_f = f.seek(0, SEEK_END)
    yield f"{min(byte_count + skip, bytes_in_f):0>8x}"


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        prog="hex_dump.py",
        description="Display bytes in a file.",
    )

    parser.add_argument(
        "file",
        type=argparse.FileType(mode="rb"),
        metavar="FILE",
        help="target file to dump",
    )

    parser.add_argument(
        "-b",
        "--binary",
        action="store_true",
        help="display bytes in binary instead of hex",
    )

    parser.add_argument(
        "-s",
        "--skip",
        type=int,
        default=0,
        help="skip SKIP bytes from the beginning",
    )

    parser.add_argument(
        "-n",
        "--length",
        type=int,
        default=math.inf,
        help="read up to LENGTH bytes",
    )

    args = parser.parse_args()
    formatter = binaryFormatter if args.binary else canonicalFormatter

    for line in hex_dump(
        args.file,
        formatter=formatter,
        skip=args.skip,
        length=args.length,
    ):
        print(line)
