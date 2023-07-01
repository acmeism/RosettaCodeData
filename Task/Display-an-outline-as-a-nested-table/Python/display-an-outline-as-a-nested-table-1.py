"""Display an outline as a nested table. Requires Python >=3.6."""

import itertools
import re
import sys

from collections import deque
from typing import NamedTuple


RE_OUTLINE = re.compile(r"^((?: |\t)*)(.+)$", re.M)

COLORS = itertools.cycle(
    [
        "#ffffe6",
        "#ffebd2",
        "#f0fff0",
        "#e6ffff",
        "#ffeeff",
    ]
)


class Node:
    def __init__(self, indent, value, parent, children=None):
        self.indent = indent
        self.value = value
        self.parent = parent
        self.children = children or []

        self.color = None

    def depth(self):
        if self.parent:
            return self.parent.depth() + 1
        return -1

    def height(self):
        """Height of the subtree rooted at this node."""
        if not self.children:
            return 0
        return max(child.height() for child in self.children) + 1

    def colspan(self):
        if self.leaf:
            return 1
        return sum(child.colspan() for child in self.children)

    @property
    def leaf(self):
        return not bool(self.children)

    def __iter__(self):
        # Level order tree traversal.
        q = deque()
        q.append(self)
        while q:
            node = q.popleft()
            yield node
            q.extend(node.children)


class Token(NamedTuple):
    indent: int
    value: str


def tokenize(outline):
    """Generate ``Token``s from the given outline."""
    for match in RE_OUTLINE.finditer(outline):
        indent, value = match.groups()
        yield Token(len(indent), value)


def parse(outline):
    """Return the given outline as a tree of ``Node``s."""
    # Split the outline into lines and count the level of indentation.
    tokens = list(tokenize(outline))

    # Parse the tokens into a tree of nodes.
    temp_root = Node(-1, "", None)
    _parse(tokens, 0, temp_root)

    # Pad the tree so that all branches have the same depth.
    root = temp_root.children[0]
    pad_tree(root, root.height())

    return root


def _parse(tokens, index, node):
    """Recursively build a tree of nodes.

    Args:
        tokens (list): A collection of ``Token``s.
        index (int): Index of the current token.
        node (Node): Potential parent or sibling node.
    """
    # Base case. No more lines.
    if index >= len(tokens):
        return

    token = tokens[index]

    if token.indent == node.indent:
        # A sibling of node
        current = Node(token.indent, token.value, node.parent)
        node.parent.children.append(current)
        _parse(tokens, index + 1, current)

    elif token.indent > node.indent:
        # A child of node
        current = Node(token.indent, token.value, node)
        node.children.append(current)
        _parse(tokens, index + 1, current)

    elif token.indent < node.indent:
        # Try the node's parent until we find a sibling.
        _parse(tokens, index, node.parent)


def pad_tree(node, height):
    """Pad the tree with blank nodes so all branches have the same depth."""
    if node.leaf and node.depth() < height:
        pad_node = Node(node.indent + 1, "", node)
        node.children.append(pad_node)

    for child in node.children:
        pad_tree(child, height)


def color_tree(node):
    """Walk the tree and color each node as we go."""
    if not node.value:
        node.color = "#F9F9F9"
    elif node.depth() <= 1:
        node.color = next(COLORS)
    else:
        node.color = node.parent.color

    for child in node.children:
        color_tree(child)


def table_data(node):
    """Return an HTML table data element for the given node."""
    indent = "    "

    if node.colspan() > 1:
        colspan = f'colspan="{node.colspan()}"'
    else:
        colspan = ""

    if node.color:
        style = f'style="background-color: {node.color};"'
    else:
        style = ""

    attrs = " ".join([colspan, style])
    return f"{indent}<td{attrs}>{node.value}</td>"


def html_table(tree):
    """Return the tree as an HTML table."""
    # Number of columns in the table.
    table_cols = tree.colspan()

    # Running count of columns in the current row.
    row_cols = 0

    # HTML buffer
    buf = ["<table style='text-align: center;'>"]

    # Breadth first iteration.
    for node in tree:
        if row_cols == 0:
            buf.append("  <tr>")

        buf.append(table_data(node))
        row_cols += node.colspan()

        if row_cols == table_cols:
            buf.append("  </tr>")
            row_cols = 0

    buf.append("</table>")
    return "\n".join(buf)


def wiki_table_data(node):
    """Return an wiki table data string for the given node."""
    if not node.value:
        return "|  |"

    if node.colspan() > 1:
        colspan = f"colspan={node.colspan()}"
    else:
        colspan = ""

    if node.color:
        style = f'style="background: {node.color};"'
    else:
        style = ""

    attrs = " ".join([colspan, style])
    return f"| {attrs} | {node.value}"


def wiki_table(tree):
    """Return the tree as a wiki table."""
    # Number of columns in the table.
    table_cols = tree.colspan()

    # Running count of columns in the current row.
    row_cols = 0

    # HTML buffer
    buf = ['{| class="wikitable" style="text-align: center;"']

    for node in tree:
        if row_cols == 0:
            buf.append("|-")

        buf.append(wiki_table_data(node))
        row_cols += node.colspan()

        if row_cols == table_cols:
            row_cols = 0

    buf.append("|}")
    return "\n".join(buf)


def example(table_format="wiki"):
    """Write an example table to stdout in either HTML or Wiki format."""

    outline = (
        "Display an outline as a nested table.\n"
        "    Parse the outline to a tree,\n"
        "        measuring the indent of each line,\n"
        "        translating the indentation to a nested structure,\n"
        "        and padding the tree to even depth.\n"
        "    count the leaves descending from each node,\n"
        "        defining the width of a leaf as 1,\n"
        "        and the width of a parent node as a sum.\n"
        "            (The sum of the widths of its children)\n"
        "    and write out a table with 'colspan' values\n"
        "        either as a wiki table,\n"
        "        or as HTML."
    )

    tree = parse(outline)
    color_tree(tree)

    if table_format == "wiki":
        print(wiki_table(tree))
    else:
        print(html_table(tree))


if __name__ == "__main__":
    args = sys.argv[1:]

    if len(args) == 1:
        table_format = args[0]
    else:
        table_format = "wiki"

    example(table_format)
