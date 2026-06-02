from __future__ import annotations

PRECEDENCE = {"^": 4, "*": 3, "/": 3, "+": 2, "-": 2}
ASSOCIATIVITY = {"^": 1, "*": 0, "/": 0, "+": 0, "-": 0}


class Node:
    def __init__(self, x: Node | str, op: str, y: Node | str | None = None):
        self.precedence = PRECEDENCE[op]
        self.right_associative = ASSOCIATIVITY[op]
        self.op = op
        self.x, self.y = x, y

    def __str__(self):
        # easy case, Node is unary
        if self.y is None:
            return "%s(%s)" % (self.op, str(self.x))

        # determine left side string
        str_y = str(self.y)
        if (
            self.y < self
            or (self.y == self and self.right_associative)
            or (str_y[0] == "-" and self.right_associative)
        ):
            str_y = "(%s)" % str_y

        # determine right side string and operator
        str_x = str(self.x)
        str_op = self.op
        if self.op == "+" and not isinstance(self.x, Node) and str_x[0] == "-":
            str_x = str_x[1:]
            str_op = "-"
        elif self.op == "-" and not isinstance(self.x, Node) and str_x[0] == "-":
            str_x = str_x[1:]
            str_op = "+"
        elif self.x < self or (
            self.x == self
            and not self.right_associative
            and getattr(self.x, "op", 1) != getattr(self, "op", 2)
        ):
            str_x = "(%s)" % str_x

        return " ".join([str_y, str_op, str_x])

    def __repr__(self):
        return "Node(%s,%s,%s)" % (repr(self.x), repr(self.op), repr(self.y))

    def __lt__(self, other: object) -> bool:
        if isinstance(other, Node):
            return self.precedence < other.precedence
        return self.precedence < PRECEDENCE.get(str(other), 9)

    def __gt__(self, other: object) -> bool:
        if isinstance(other, Node):
            return self.precedence > other.precedence
        return self.precedence > PRECEDENCE.get(str(other), 9)

    def __eq__(self, other: object) -> bool:
        if isinstance(other, Node):
            return self.precedence == other.precedence
        return self.precedence > PRECEDENCE.get(str(other), 9)


def rpn_to_infix(input: str, *, VERBOSE: bool = False):
    """Convert `input` in rpn notation to infix notation."""
    if VERBOSE:
        print("TOKEN  STACK")

    stack: list[Node | str] = []
    for token in input.replace("^", "^").split():
        if token in PRECEDENCE:
            stack.append(Node(stack.pop(), token, stack.pop()))
        else:
            stack.append(token)

        if VERBOSE:
            print(token + " " * (7 - len(token)) + repr(stack))

    return str(stack[0])


if __name__ == "__main__":
    EXAMPLES = [
        "3 4 2 * 1 5 - 2 3 ^ ^ / +",
        "1 2 + 3 4 + ^ 5 6 + ^",
    ]

    for example in EXAMPLES:
        print(f"Input: {example}")
        print(f"Result: {rpn_to_infix(example, VERBOSE=True)}")
        print()

