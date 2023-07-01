"""Huffman encoding and decoding. Requires Python >= 3.7."""
from __future__ import annotations

from collections import Counter

from heapq import heapify
from heapq import heappush
from heapq import heappop

from itertools import chain
from itertools import islice

from typing import BinaryIO
from typing import Dict
from typing import Iterable
from typing import Optional
from typing import Tuple


LEFT_BIT = "0"
RIGHT_BIT = "1"
WORD_SIZE = 8  # Assumed to be a multiple of 8.
READ_SIZE = WORD_SIZE // 8
P_EOF = 1 << WORD_SIZE


class Node:
    """Huffman tree node."""

    def __init__(
        self,
        weight: int,
        symbol: Optional[int] = None,
        left: Optional[Node] = None,
        right: Optional[Node] = None,
    ):
        self.weight = weight
        self.symbol = symbol
        self.left = left
        self.right = right

    def is_leaf(self) -> bool:
        """Return `True` if this node is a leaf node, or `False` otherwise."""
        return self.left is None and self.right is None

    def __lt__(self, other: Node) -> bool:
        return self.weight < other.weight


def huffman_tree(weights: Dict[int, int]) -> Node:
    """Build a prefix tree from a map of symbol frequencies."""
    heap = [Node(v, k) for k, v in weights.items()]
    heapify(heap)

    # Pseudo end-of-file with a weight of 1.
    heappush(heap, Node(1, P_EOF))

    while len(heap) > 1:
        left, right = heappop(heap), heappop(heap)
        node = Node(weight=left.weight + right.weight, left=left, right=right)
        heappush(heap, node)

    return heappop(heap)


def huffman_table(tree: Node) -> Dict[int, str]:
    """Build a table of prefix codes by visiting every leaf node in `tree`."""
    codes: Dict[int, str] = {}

    def walk(node: Optional[Node], code: str = ""):
        if node is None:
            return

        if node.is_leaf():
            assert node.symbol
            codes[node.symbol] = code
            return

        walk(node.left, code + LEFT_BIT)
        walk(node.right, code + RIGHT_BIT)

    walk(tree)
    return codes


def huffman_encode(data: bytes) -> Tuple[Iterable[bytes], Node]:
    """Encode the given byte string using Huffman coding.

    Returns the encoded byte stream and the Huffman tree required to
    decode those bytes.
    """
    weights = Counter(data)
    tree = huffman_tree(weights)
    table = huffman_table(tree)
    return _encode(data, table), tree


def huffman_decode(data: Iterable[bytes], tree: Node) -> bytes:
    """Decode the given byte stream using a Huffman tree."""
    return bytes(_decode(_bits_from_bytes(data), tree))


def _encode(stream: Iterable[int], codes: Dict[int, str]) -> Iterable[bytes]:
    bits = chain(chain.from_iterable(codes[s] for s in stream), codes[P_EOF])

    # Pack bits (stream of 1s and 0s) one word at a time.
    while True:
        word = "".join(islice(bits, WORD_SIZE))  # Most significant bit first.
        if not word:
            break

        # Pad last bits if they don't align to a whole word.
        if len(word) < WORD_SIZE:
            word = word.ljust(WORD_SIZE, "0")

        # Byte order becomes relevant when READ_SIZE > 1.
        yield int(word, 2).to_bytes(READ_SIZE, byteorder="big", signed=False)


def _decode(bits: Iterable[str], tree: Node) -> Iterable[int]:
    node = tree

    for bit in bits:
        if bit == LEFT_BIT:
            assert node.left
            node = node.left
        else:
            assert node.right
            node = node.right

        if node.symbol == P_EOF:
            break

        if node.is_leaf():
            assert node.symbol
            yield node.symbol
            node = tree  # Back to the top of the tree.


def _word_to_bits(word: bytes) -> str:
    """Return the binary representation of a word given as a byte string,
    including leading zeros up to WORD_SIZE.

    For example, when WORD_SIZE is 8:
        _word_to_bits(b'65') == '01000001'
    """
    i = int.from_bytes(word, "big")
    return bin(i)[2:].zfill(WORD_SIZE)


def _bits_from_file(file: BinaryIO) -> Iterable[str]:
    """Generate a stream of bits (strings of either "0" or "1") from file-like
    object `file`, opened in binary mode."""
    word = file.read(READ_SIZE)
    while word:
        yield from _word_to_bits(word)
        word = file.read(READ_SIZE)


def _bits_from_bytes(stream: Iterable[bytes]) -> Iterable[str]:
    """Generate a stream of bits (strings of either "0" or "1") from an
    iterable of single byte byte-strings."""
    return chain.from_iterable(_word_to_bits(byte) for byte in stream)


def main():
    """Example usage."""
    s = "this is an example for huffman encoding"
    data = s.encode()  # Need a byte string
    encoded, tree = huffman_encode(data)

    # Pretty print the Huffman table
    print(f"Symbol Code\n------ ----")
    for k, v in sorted(huffman_table(tree).items(), key=lambda x: len(x[1])):
        print(f"{chr(k):<6} {v}")

    # Print the bit pattern of the encoded data
    print("".join(_bits_from_bytes(encoded)))

    # Encode then decode
    decoded = huffman_decode(*huffman_encode(data))
    print(decoded.decode())


if __name__ == "__main__":
    main()
