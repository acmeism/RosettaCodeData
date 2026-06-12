from abc import ABC
from abc import abstractmethod
from collections import deque
from collections.abc import Callable
from enum import StrEnum
from fractions import Fraction
from operator import add
from operator import mul
from operator import neg
from operator import pos
from operator import sub
from operator import truediv
from typing import ClassVar

from pest import Pair
from pest import Parser
from pest import PrattParser

GRAMMAR = r"""
program  =   { SOI ~ expr ~ EOI }
expr     =   { prefix* ~ primary ~ (infix ~ prefix* ~ primary)* }
infix    =  _{ add | sub | mul | div }
add      =   { "+" }
sub      =   { "-" }
mul      =   { "*" }
div      =   { "/" }
prefix   =  _{ pos | neg | abs }
pos      =   { "+" }
neg      =   { "-" }
abs      =   { "abs" }
primary  =  _{ int | history | "(" ~ expr ~ ")" }
int      =  @{ (ASCII_NONZERO_DIGIT ~ ASCII_DIGIT+ | ASCII_DIGIT) }
history  =   { "@" }

WHITESPACE   =  _{ " " | "\t" | NEWLINE }
"""

PARSER = Parser.from_grammar(GRAMMAR)

class Rule(StrEnum):
    PROGRAM = "program"
    EXPR = "expr"
    ADD = "add"
    SUB = "sub"
    MUL = "mul"
    DIV = "div"
    POS = "pos"
    NEG = "neg"
    ABS = "abs"
    INT = "int"
    HISTORY = "history"

class Expression(ABC):
    @abstractmethod
    def evaluate(self, history: deque[Fraction]) -> Fraction: ...

class IntExpr(Expression):
    def __init__(self, value: str) -> None:
        self.rat = Fraction(value)

    def evaluate(self, history: deque[Fraction]) -> Fraction:
        return self.rat

class HistExpr(Expression):
    def evaluate(self, history: deque[Fraction]) -> Fraction:
        return history[-1] if history else Fraction()

class PrefixExpr(Expression):
    def __init__(self, op: Callable[[Fraction], Fraction], right: Expression) -> None:
        self.op = op
        self.right = right

    def evaluate(self, history: deque[Fraction]) -> Fraction:
        return self.op(self.right.evaluate(history))

class InfixExpr(Expression):
    def __init__(
        self,
        op: Callable[[Fraction, Fraction], Fraction],
        left: Expression,
        right: Expression,
    ) -> None:
        self.op = op
        self.left = left
        self.right = right

    def evaluate(self, history: deque[Fraction]) -> Fraction:
        return self.op(self.left.evaluate(history), self.right.evaluate(history))

class CalculatorParser(PrattParser[Expression]):
    PREFIX_OPS: ClassVar[dict[str, int]] = {
        Rule.NEG: 6,
        Rule.POS: 6,
        Rule.ABS: 6,
    }

    POSTFIX_OPS: ClassVar[dict[str, int]] = {}

    INFIX_OPS: ClassVar[dict[str, tuple[int, bool]]] = {
        Rule.ADD: (3, PrattParser.LEFT_ASSOC),
        Rule.SUB: (3, PrattParser.LEFT_ASSOC),
        Rule.MUL: (4, PrattParser.LEFT_ASSOC),
        Rule.DIV: (4, PrattParser.LEFT_ASSOC),
    }

    def parse(self, expr: str) -> Expression:
        pairs = PARSER.parse(Rule.PROGRAM, expr)
        return self.parse_expr(pairs.first().inner().first().stream())

    def parse_primary(self, pair: Pair) -> Expression:
        match pair:
            case Pair(Rule.INT):
                return IntExpr(pair.text)
            case Pair(Rule.HISTORY):
                return HistExpr()
            case Pair(Rule.EXPR):
                return self.parse_expr(pair.stream())
            case _:
                raise Exception(f"unexpected {pair.text!r}")

    def parse_prefix(self, op: Pair, rhs: Expression) -> Expression:
        match op:
            case Pair(Rule.POS):
                return PrefixExpr(pos, rhs)
            case Pair(Rule.NEG):
                return PrefixExpr(neg, rhs)
            case Pair(Rule.ABS):
                return PrefixExpr(abs, rhs)
            case _:
                raise Exception(f"unknown prefix operator {op.text!r}")

    def parse_postfix(self, lhs: Expression, op: Pair) -> Expression:
        raise Exception(f"unknown postfix operator {op.text!r}")

    def parse_infix(self, lhs: Expression, op: Pair, rhs: Expression) -> Expression:
        match op.rule.name:
            case Rule.ADD:
                return InfixExpr(add, lhs, rhs)
            case Rule.SUB:
                return InfixExpr(sub, lhs, rhs)
            case Rule.MUL:
                return InfixExpr(mul, lhs, rhs)
            case Rule.DIV:
                return InfixExpr(truediv, lhs, rhs)
            case _:
                raise Exception(f"unknown infix operator {op.text!r}")

def format_rat(rat: Fraction) -> str:
    sign = "-" if rat.numerator * rat.denominator < 0 else ""
    n = abs(rat.numerator)
    d = abs(rat.denominator)

    integer_part = n // d
    r = n % d

    if r == 0:
        return f"{sign}{integer_part}"

    digits: list[str] = []
    seen: dict[int, int] = {}
    pos = 0

    while r and r not in seen:
        seen[r] = pos
        r *= 10
        digit = r // d
        digits.append(str(digit))
        r %= d
        pos += 1

    if r == 0:
        return f"{sign}{integer_part}." + "".join(digits)

    repeat_start = seen[r]
    non_repeat = "".join(digits[:repeat_start])
    repeat = "".join(digits[repeat_start:])
    return f"{sign}{integer_part}.{non_repeat}({repeat})"

def main() -> None:
    parser = CalculatorParser()
    history: deque[Fraction] = deque(maxlen=3)

    while True:
        line = input(">")

        if not line.strip():
            break

        expr = parser.parse(line)
        rat = expr.evaluate(history)
        history.append(rat)

        print(f"={format_rat(rat)}")

if __name__ == "__main__":
    main()
