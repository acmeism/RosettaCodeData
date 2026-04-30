from __future__ import annotations

import csv
from dataclasses import astuple
from dataclasses import dataclass
from io import StringIO
from pathlib import Path

from filelock import FileLock


@dataclass
class Record:
    account: str
    password: str
    UID: int
    GID: int
    GECOS: GECOS
    directory: str
    shell: str


@dataclass
class GECOS:
    fullname: str
    office: str
    extension: str
    homephone: str
    email: str


PASSWDS = [
    Record(
        "jsmith",
        "x",
        1001,
        1000,
        GECOS(
            "Joe Smith",
            "Room 1007",
            "(234)555-8917",
            "(234)555-0077",
            "jsmith@rosettacode.org",
        ),
        "/home/jsmith",
        "/bin/bash",
    ),
    Record(
        "jdoe",
        "x",
        1002,
        1000,
        GECOS(
            "Jane Doe",
            "Room 1004",
            "(234)555-8914",
            "(234)555-0044",
            "jdoe@rosettacode.org",
        ),
        "/home/jdoe",
        "/bin/bash",
    ),
]


class RecordDialect(csv.unix_dialect):
    delimiter = ":"
    quoting = csv.QUOTE_NONE


class GECOSDialect(RecordDialect):
    delimiter = ","
    lineterminator = ""


def row(record: Record) -> list[str | int]:
    gecos_buffer = StringIO()
    gecos_writer = csv.writer(gecos_buffer, dialect=GECOSDialect)
    gecos_writer.writerow(astuple(record.GECOS))

    return [
        record.account,
        record.password,
        record.UID,
        record.GID,
        gecos_buffer.getvalue(),
        record.directory,
        record.shell,
    ]


if __name__ == "__main__":
    path = Path("passwd.txt")
    lock = FileLock("passwd.txt.lock")

    with lock:
        with path.open("w") as fd:
            record_writer = csv.writer(fd, dialect=RecordDialect)
            record_writer.writerows(row(r) for r in PASSWDS)

    with lock:
        print(f"Before append:\n\n{path.read_text()}")

    new_record = Record(
        "xyz",
        "x",
        1003,
        1001,
        GECOS(
            "X Yz",
            "Room 1003",
            "(234)555-8913",
            "(234)555-0033",
            "xyz@rosettacode.org",
        ),
        "/home/xyz",
        "/bin/bash",
    )

    with lock:
        with path.open("a") as fd:
            record_writer = csv.writer(fd, dialect=RecordDialect)
            record_writer.writerow(row(new_record))

    with lock:
        print(f"After append:\n\n{path.read_text()}")
