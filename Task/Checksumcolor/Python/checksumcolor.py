#!/usr/bin/env python
"""Colorize MD5 or SHA checksums read from stdin or files.

Tested with Python 2.7 and 3.8.
"""

from __future__ import unicode_literals

import argparse
import fileinput
import os
import sys

from functools import partial
from itertools import count
from itertools import takewhile


ANSI_RESET = "\u001b[0m"

RED = (255, 0, 0)
GREEN = (0, 255, 0)
YELLOW = (255, 255, 0)
BLUE = (0, 0, 255)
MAGENTA = (255, 0, 255)
CYAN = (0, 255, 255)

ANSI_PALETTE = {
    RED: "\u001b[31m",
    GREEN: "\u001b[32m",
    YELLOW: "\u001b[33m",
    BLUE: "\u001b[34m",
    MAGENTA: "\u001b[35m",
    CYAN: "\u001b[36m",
}

# Some alternative, 8-bit colors. This is just one row from the table at
# https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit
_8BIT_PALETTE = {
    (0xAF, 0x00, 0x00): "\u001b[38;5;124m",
    (0xAF, 0x00, 0x5F): "\u001b[38;5;125m",
    (0xAF, 0x00, 0x87): "\u001b[38;5;126m",
    (0xAF, 0x00, 0xAF): "\u001b[38;5;127m",
    (0xAF, 0x00, 0xD7): "\u001b[38;5;128m",
    (0xAF, 0x00, 0xFF): "\u001b[38;5;129m",
    (0xAF, 0x5F, 0x00): "\u001b[38;5;130m",
    (0xAF, 0x5F, 0x5F): "\u001b[38;5;131m",
    (0xAF, 0x5F, 0x87): "\u001b[38;5;132m",
    (0xAF, 0x5F, 0xAF): "\u001b[38;5;133m",
    (0xAF, 0x5F, 0xD7): "\u001b[38;5;134m",
    (0xAF, 0x5F, 0xFF): "\u001b[38;5;135m",
    (0xAF, 0x87, 0x00): "\u001b[38;5;136m",
    (0xAF, 0x87, 0x5F): "\u001b[38;5;137m",
    (0xAF, 0x87, 0x87): "\u001b[38;5;138m",
    (0xAF, 0x87, 0xAF): "\u001b[38;5;139m",
    (0xAF, 0x87, 0xD7): "\u001b[38;5;140m",
    (0xAF, 0x87, 0xFF): "\u001b[38;5;141m",
    (0xAF, 0xAF, 0x00): "\u001b[38;5;142m",
    (0xAF, 0xAF, 0x5F): "\u001b[38;5;143m",
    (0xAF, 0xAF, 0x87): "\u001b[38;5;144m",
    (0xAF, 0xAF, 0xAF): "\u001b[38;5;145m",
    (0xAF, 0xAF, 0xD7): "\u001b[38;5;146m",
    (0xAF, 0xAF, 0xFF): "\u001b[38;5;147m",
    (0xAF, 0xD7, 0x00): "\u001b[38;5;148m",
    (0xAF, 0xD7, 0x5F): "\u001b[38;5;149m",
    (0xAF, 0xD7, 0x87): "\u001b[38;5;150m",
    (0xAF, 0xD7, 0xAF): "\u001b[38;5;151m",
    (0xAF, 0xD7, 0xD7): "\u001b[38;5;152m",
    (0xAF, 0xD7, 0xFF): "\u001b[38;5;153m",
    (0xAF, 0xFF, 0x00): "\u001b[38;5;154m",
    (0xAF, 0xFF, 0x5F): "\u001b[38;5;155m",
    (0xAF, 0xFF, 0x87): "\u001b[38;5;156m",
    (0xAF, 0xFF, 0xAF): "\u001b[38;5;157m",
    (0xAF, 0xFF, 0xD7): "\u001b[38;5;158m",
    (0xAF, 0xFF, 0xFF): "\u001b[38;5;159m",
}


def error(msg):
    """Exit with an error message."""
    sys.stderr.write(msg)
    sys.stderr.write(os.linesep)
    sys.exit(1)


def rgb(group):
    """Derive an RGB color from a hexadecimal string."""
    nibbles_per_channel = len(group) // 3
    max_val = 16 ** nibbles_per_channel - 1
    nibbles = chunked(group, nibbles_per_channel)

    # Transform hex values into the range 0 to 255.
    return tuple((int(n, 16) * 255) // max_val for n in nibbles)


def distance(color, other):
    """Return the difference between two colors. Both ``color`` and ``other``
    are three-tuples of RGB values.

    Uses a simplfied Euclidean distance, as described at
    https://en.wikipedia.org/wiki/Color_difference#sRGB
    """
    return sum((o - s) ** 2 for s, o in zip(color, other))


def chunked(seq, n):
    """Split the given sequence into chunks of size `n`. The last item in the
    sequence could have a length less than `n`.
    """
    return takewhile(len, (seq[i : i + n] for i in count(0, n)))


def escape(group, palette):
    """Return the given checksum group wrapped with ANSI escape codes."""
    key = partial(distance, other=rgb(group.ljust(3, "0")))
    ansi_color = min(palette, key=key)
    return "".join([palette[ansi_color], group, ANSI_RESET])


def colorize(line, group_size=3, palette=ANSI_PALETTE):
    """Write a colorized version of the given checksum to stdout."""
    checksum, filename = line.split(None, 1)
    escaped = [escape(group, palette) for group in chunked(checksum, group_size)]
    sys.stdout.write("  ".join(["".join(escaped), filename]))


def html_colorize(checksum, group_size=3, palette=ANSI_PALETTE):
    """Helper function for generating colorized checksums suitable for display
    on RosettaCode."""

    def span(group):
        key = partial(distance, other=rgb(group.ljust(3, "0")))
        ansi_color = min(palette, key=key)
        int_val = int.from_bytes(ansi_color, byteorder="big")
        hex_val = hex(int_val)[2:].rjust(6, "0")
        return '<span style="color:#{}">{}</span>'.format(hex_val, group)

    checksum, filename = line.split(None, 1)
    escaped = [span(group) for group in chunked(checksum, group_size)]
    sys.stdout.write("  ".join(["".join(escaped), filename]))


if __name__ == "__main__":
    # Command line interface
    parser = argparse.ArgumentParser(description="Color checksum.")

    parser.add_argument(
        "-n",
        type=int,
        default=3,
        help="Color the checksum in groups of size N. Defaults to 3.",
    )

    parser.add_argument(
        "-e",
        "--extended-palette",
        action="store_true",
        help="Use the extended 8-bit palette. Defaults to False.",
    )

    parser.add_argument(
        "--html",
        action="store_true",
        help="Output checksum groups wrapped with 'span' tags instead of ANSI escape sequences.",
    )

    parser.add_argument("files", nargs="*", default="-", metavar="FILE")

    args = parser.parse_args()

    if sys.stdout.isatty():

        palette = ANSI_PALETTE
        if args.extended_palette:
            palette = _8BIT_PALETTE

        colorize_func = colorize
        if args.html:
            colorize_func = html_colorize

        for line in fileinput.input(files=args.files):
            colorize_func(line, group_size=args.n, palette=palette)
    else:
        # Piped or redirected. Don't colorize.
        for line in fileinput.input(files=args.files):
            sys.stdout.write(line)
