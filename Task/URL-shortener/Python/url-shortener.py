"""A URL shortener using Flask. Requires Python >=3.5."""

import sqlite3
import string
import random

from http import HTTPStatus

from flask import Flask
from flask import Blueprint
from flask import abort
from flask import current_app
from flask import g
from flask import jsonify
from flask import redirect
from flask import request
from flask import url_for


CHARS = frozenset(string.ascii_letters + string.digits)
MIN_URL_SIZE = 8
RANDOM_ATTEMPTS = 3


def create_app(*, db=None, server_name=None) -> Flask:
    app = Flask(__name__)
    app.config.from_mapping(
        DATABASE=db or "shorten.sqlite",
        SERVER_NAME=server_name,
    )

    with app.app_context():
        init_db()

    app.teardown_appcontext(close_db)
    app.register_blueprint(shortener)

    return app


def get_db():
    if "db" not in g:
        g.db = sqlite3.connect(current_app.config["DATABASE"])
        g.db.row_factory = sqlite3.Row

    return g.db


def close_db(_):
    db = g.pop("db", None)

    if db is not None:
        db.close()


def init_db():
    db = get_db()

    with db:
        db.execute(
            "CREATE TABLE IF NOT EXISTS shorten ("
            "url TEXT PRIMARY KEY, "
            "short TEXT NOT NULL UNIQUE ON CONFLICT FAIL)"
        )


shortener = Blueprint("shorten", "short")


def random_short(size=MIN_URL_SIZE):
    """Return a random URL-safe string `size` characters in length."""
    return "".join(random.sample(CHARS, size))


@shortener.errorhandler(HTTPStatus.NOT_FOUND)
def short_url_not_found(_):
    return "short url not found", HTTPStatus.NOT_FOUND


@shortener.route("/<path:key>", methods=("GET",))
def short(key):
    db = get_db()

    cursor = db.execute("SELECT url FROM shorten WHERE short = ?", (key,))
    row = cursor.fetchone()

    if row is None:
        abort(HTTPStatus.NOT_FOUND)

    # NOTE: Your might want to change this to HTTPStatus.MOVED_PERMANENTLY
    return redirect(row["url"], code=HTTPStatus.FOUND)


class URLExistsError(Exception):
    """Exception raised when we try to insert a URL that is already in the database."""


class ShortCollisionError(Exception):
    """Exception raised when a short URL is already in use."""


def _insert_short(long_url, short):
    """Helper function that checks for database integrity errors explicitly
    before inserting a new URL."""
    db = get_db()

    if (
        db.execute("SELECT * FROM shorten WHERE url = ?", (long_url,)).fetchone()
        is not None
    ):
        raise URLExistsError(long_url)

    if (
        db.execute("SELECT * FROM shorten WHERE short = ?", (short,)).fetchone()
        is not None
    ):
        raise ShortCollisionError(short)

    with db:
        db.execute("INSERT INTO shorten VALUES (?, ?)", (long_url, short))


def make_short(long_url):
    """Generate a new short URL for the given long URL."""
    size = MIN_URL_SIZE
    attempts = 1
    short = random_short(size=size)

    while True:
        try:
            _insert_short(long_url, short)
        except ShortCollisionError:
            # Increase the short size if we keep getting collisions.
            if not attempts % RANDOM_ATTEMPTS:
                size += 1

            attempts += 1
            short = random_short(size=size)
        else:
            break

    return short


@shortener.route("/", methods=("POST",))
def shorten():
    data = request.get_json()

    if data is None:
        abort(HTTPStatus.BAD_REQUEST)

    long_url = data.get("long")

    if long_url is None:
        abort(HTTPStatus.BAD_REQUEST)

    db = get_db()

    # Does this URL already have a short?
    cursor = db.execute("SELECT short FROM shorten WHERE url = ?", (long_url,))
    row = cursor.fetchone()

    if row is not None:
        short_url = url_for("shorten.short", _external=True, key=row["short"])
        status_code = HTTPStatus.OK
    else:
        short_url = url_for("shorten.short", _external=True, key=make_short(long_url))
        status_code = HTTPStatus.CREATED

    mimetype = request.accept_mimetypes.best_match(
        matches=["text/plain", "application/json"], default="text/plain"
    )

    if mimetype == "application/json":
        return jsonify(long=long_url, short=short_url), status_code
    else:
        return short_url, status_code


if __name__ == "__main__":
    # Start the development server
    app = create_app()
    app.env = "development"
    app.run(debug=True)
