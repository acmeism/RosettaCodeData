use DBIish;

my $dbh = DBIish.connect('SQLite', :database<addresses.sqlite3>);

my $sth = $dbh.do(q:to/STATEMENT/);
    DROP TABLE IF EXISTS Address;
    CREATE TABLE Address (
        addrID      INTEGER PRIMARY KEY AUTOINCREMENT,
        addrStreet  TEXT NOT NULL,
        addrCity    TEXT NOT NULL,
        addrState   TEXT NOT NULL,
        addrZIP     TEXT NOT NULL
    )
    STATEMENT
