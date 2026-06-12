#!/usr/bin/env python
"""Rosetta Code compiler/preprocessor. Requires Python >= 3.7."""
import re
import sys

from typing import Dict
from typing import Iterator
from typing import List
from typing import NamedTuple
from typing import Optional
from typing import TextIO
from typing import Tuple

MAX_INCLUDE_DEPTH = 5

TOKEN_INCLUDE = "INCLUDE"
TOKEN_CONSTANT = "CONSTANT"
TOKEN_MACRO = "MACRO"
TOKEN_CALL = "CALL"
TOKEN_STRING = "STRING"
TOKEN_COMMENT = "COMMENT"
TOKEN_LITERAL = "LITERAL"
TOKEN_ILLEGAL = "ILLEGAL"


class Token(NamedTuple):
    kind: str
    name: str
    params: str
    expr: str
    start: int
    end: int


FILENAME_PATTERN = r"[_a-zA-Z][_a-zA-Z0-9\.]*"
IDENT_PATTERN = r"[_a-zA-Z][_a-zA-Z0-9]*"
PARAMS_PATTERN = r"[_a-zA-Z0-9\., \t]*?"

TOKEN_RULES = (
    (
        TOKEN_STRING,
        r"\"[^\"\n]*?\"",
    ),
    (
        TOKEN_COMMENT,
        r"/\*.*?\*/",
    ),
    (
        TOKEN_LITERAL,
        r"[^#]+",
    ),
    (
        TOKEN_INCLUDE,
        rf"^\#include[ \t]+\"(?P<filename>{FILENAME_PATTERN})\"\s*?$",
    ),
    (
        TOKEN_CONSTANT,
        rf"^\#define[ \t]+(?P<constant>{IDENT_PATTERN}) +(?P<constant_expr>.*?)$",
    ),
    (
        TOKEN_MACRO,
        rf"^\#define[ \t](?P<macro>{IDENT_PATTERN})"
        rf"\((?P<macro_params>{PARAMS_PATTERN})\) +(?P<macro_expr>.*?)$",
    ),
    (
        TOKEN_CALL,
        rf"\#(?P<call>{IDENT_PATTERN})\((?P<call_params>{PARAMS_PATTERN})\)\#",
    ),
    (
        TOKEN_ILLEGAL,
        r".",
    ),
)

RE_TOKENS = re.compile(
    "|".join(f"(?P<{name}>{pattern})" for name, pattern in TOKEN_RULES),
    re.MULTILINE,
)


class PreprocessorError(Exception):
    def __init__(
        self,
        *args: object,
        source: str,
        filename: str,
        token: Token,
    ) -> None:
        super().__init__(*args)
        self.source = source
        self.token = token
        self.filename = filename

    def __str__(self) -> str:
        msg = super().__str__()
        line_num = self.source[: self.token.start].count("\n") + 1
        return f"{msg} ({self.filename}:{line_num})"


def tokenize(source: str, filename: str) -> Iterator[Token]:
    for match in RE_TOKENS.finditer(source):
        kind = match.lastgroup

        if kind in (TOKEN_LITERAL, TOKEN_COMMENT, TOKEN_STRING):
            yield Token(
                TOKEN_LITERAL,
                "",
                "",
                match.group(),
                match.start(),
                match.end(),
            )
        elif kind == TOKEN_INCLUDE:
            yield Token(
                TOKEN_INCLUDE,
                "",
                "",
                match.group("filename"),
                match.start(),
                match.end(),
            )
        elif kind == TOKEN_CONSTANT:
            yield Token(
                kind,
                match.group("constant"),
                "",
                match.group("constant_expr"),
                match.start(),
                match.end(),
            )
        elif kind == TOKEN_MACRO:
            yield Token(
                kind,
                match.group("macro"),
                match.group("macro_params"),
                match.group("macro_expr"),
                match.start(),
                match.end(),
            )
        elif kind == TOKEN_CALL:
            yield Token(
                kind,
                match.group("call"),
                match.group("call_params"),
                "",
                match.start(),
                match.end(),
            )
        elif kind == TOKEN_ILLEGAL:
            # Probably part of an invalid macro call
            yield Token(
                TOKEN_LITERAL,
                "",
                "",
                match.group(),
                match.start(),
                match.end(),
            )
        else:
            raise PreprocessorError(
                f"unexpected token kind {kind} ({match.group()!r})",
                source=source,
                filename=filename,
                token=Token(
                    TOKEN_ILLEGAL,
                    "",
                    "",
                    match.group(),
                    match.start(),
                    match.end(),
                ),
            )


def preprocess(
    source: str,
    filename: str,
    stream: TextIO,
    debug: bool = False,
    constants: Optional[Dict[str, str]] = None,
    include_depth: int = 0,
    macros: Optional[Dict[str, Tuple[str, int]]] = None,
) -> None:
    constants = constants if constants is not None else {}
    include_depth = include_depth
    macros = macros if macros is not None else {}
    left_strip = False

    for token in tokenize(source, filename):
        if token.kind == TOKEN_LITERAL:
            if left_strip:
                stream.write(_lstrip_one(token.expr))
                left_strip = False
            else:
                stream.write(token.expr)
        elif token.kind == TOKEN_CONSTANT:
            if debug:
                stream.write(f"/* Define {token.name} as {token.expr} */\n")

            if token.name in constants:
                raise PreprocessorError(
                    f"illegal constant redefinition '{token.name}'",
                    source=source,
                    filename=filename,
                    token=token,
                )

            constants[token.name] = token.expr
            left_strip = True
        elif token.kind == TOKEN_INCLUDE:
            if include_depth + 1 > MAX_INCLUDE_DEPTH:
                raise PreprocessorError(
                    "maximum include depth reached",
                    source=source,
                    filename=filename,
                    token=token,
                )

            if debug:
                stream.write(f"/* Include {token.expr} */\n")

            with open(token.expr) as fd:
                preprocess(
                    fd.read(),
                    filename,
                    stream,
                    debug,
                    constants,
                    include_depth + 1,
                    macros,
                )

            if debug:
                stream.write(f"/* End {token.expr} */\n")

            left_strip = True
        elif token.kind == TOKEN_MACRO:
            if debug:
                stream.write(
                    f"/* Define {token.name}({token.params}) as {token.expr} */\n"
                )

            if token.name in macros:
                raise PreprocessorError(
                    f"illegal macro redefinition '{token.name}'",
                    source=source,
                    filename=filename,
                    token=token,
                )

            params = parse_parameters(token.params)
            expr = parse_expression(params, token.expr)
            macros[token.name] = (expr, len(params))
            left_strip = True
        elif token.kind == TOKEN_CALL:
            params = parse_parameters(token.params)
            expr, n_args = macros.get(token.name, ("", 0))

            if debug:
                if params:
                    used = [token.name, *params]
                    stream.write(f"/* Use {', '.join(used[:-1])} and {used[-1]} */ ")
                else:
                    stream.write(f"/* Use {token.name} */ ")

            if len(params) != n_args:
                print(token.name, len(params), n_args, macros)
                stream.write(source[token.start : token.end])
            else:
                stream.write(
                    substitute_constants(
                        constants,
                        expr.format(*params),
                    )
                )

            left_strip = False
        else:
            raise PreprocessorError(
                f"unknown token kind {token}",
                source=source,
                filename=filename,
                token=token,
            )


def parse_parameters(params: str) -> List[str]:
    return [param.strip() for param in params.split(",")]


def parse_expression(params: List[str], expr: str) -> str:
    _params = {p: str(i) for i, p in enumerate(params)}
    pattern = "|".join(rf"\b{param}\b" for param in params)
    return re.sub(
        f"({pattern})",
        lambda m: f"{{{_params[m.group(0)]}}}",
        expr,
    )


def substitute_constants(constants: Dict[str, str], expr: str) -> str:
    pattern = "|".join(rf"\b{const}\b" for const in constants)
    return re.sub(
        f"({pattern})",
        lambda m: constants[m.group(0)],
        expr,
    )


def _lstrip_one(s: str) -> str:
    """Strip at most one newline from the left of `s`."""
    if s and s[0] == "\n":
        return s[1:]
    return s


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Rosetta Code compiler preprocessor.")
    parser.add_argument(
        "infile",
        nargs="?",
        type=argparse.FileType("r"),
        default=sys.stdin,
        help="source file to preprocess, '-' means stdin (default: stdin)",
    )
    parser.add_argument(
        "outfile",
        nargs="?",
        type=argparse.FileType("w"),
        default=sys.stdout,
        help="destination file (default: stdout)",
    )
    parser.add_argument(
        "--debug",
        "-d",
        action="store_true",
        help="enable debugging output (default: false)",
    )

    args = parser.parse_args()
    preprocess(args.infile.read(), args.infile.name, args.outfile, debug=args.debug)
