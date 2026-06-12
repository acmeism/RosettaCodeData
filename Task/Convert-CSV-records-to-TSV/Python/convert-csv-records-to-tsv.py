import re
from typing import Iterator
from typing import NamedTuple


RULES: list[tuple[str, str]] = [
    ("QUOTED_FIELD", r'\s*"(?P<CONTENT>(?:""|[^"])*)"\s*'),
    ("UNQUOTED_FIELD", r'[^",]+'),
    ("COMMA", r","),
    ("ERROR", r"."),
]

RE_RULES = re.compile(
    "|".join(f"(?P<{token}>{pattern})" for token, pattern in RULES),
)


class Token(NamedTuple):
    kind: str
    value: str


EOF = Token("EOF", "")


def tokenize(record: str) -> Iterator[Token]:
    for match in RE_RULES.finditer(record):
        kind = match.lastgroup
        assert kind is not None

        if kind == "QUOTED_FIELD":
            yield Token(kind, match.group("CONTENT"))
        else:
            yield Token(kind, match.group())


def parse(tokens: Iterator[Token]) -> Iterator[str]:
    token = next(tokens, EOF)

    while True:
        if token.kind in ("QUOTED_FIELD", "UNQUOTED_FIELD"):
            yield transform_field(token.value)

            if next(tokens, EOF).kind != "COMMA":
                # End of record or an error
                # Silently ignore errors
                break
        elif token.kind == "COMMA":
            # An empty field.
            yield ""
        else:
            # Silently ignore errors.
            yield ""
            break

        token = next(tokens, EOF)


def transform_field(field: str) -> str:
    return (
        field.replace('""', '"')
        .replace("\t", "\\t")
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\0", "\\0")
    )


def csv_to_tsv(line: str) -> str:
    tokens = tokenize(line)
    return "\t".join(parse(tokens))


def test() -> None:
    TEST_CASES = [
        ('a,"b"', "a\tb"),
        ('"a","b""c"', 'a\tb"c'),
        ("", ""),
        (",a", "\ta"),
        ('a,"', "a\t"),
        (' a , "b" ', " a \tb"),
        ('"12",34', "12\t34"),
        ("a\tb", "a\\tb"),
        ("a\\tb", "a\\tb"),
        ("a\\n\\rb", "a\\n\\rb"),
        ("a\0b", "a\\0b"),
        ("a\rb", "a\\rb"),
        # NOTE: Additional test cases.
        ('a,"b,c"', "a\tb,c"),  # Comma in quoted field
        ('"a" "b"', "a"),  # Whitespace and no comma between quoted fields
        ('"a"foo"b"', "a"),  # Junk and no comma between quoted fields
    ]

    for csv, tsv in TEST_CASES:
        rv = csv_to_tsv(csv)
        assert rv == tsv, f"{rv!r} != {tsv!r}"
        print(f"{csv!r:>12} => {tsv!r}")


if __name__ == "__main__":
    import argparse

    # Open files with universal new lines.
    # Pass `-` on the command line to read from the standard input stream.
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("-f", "--file", type=argparse.FileType("r"), required=False)
    group.add_argument("--test", action="store_true", required=False)
    args = parser.parse_args()

    if args.test:
        test()
    else:
        for line in args.infile:
            # Write lines/records with to stdout with os.linesep
            print(csv_to_tsv(line.strip()))
