import parseCsv, db_sqlite, sequtils, strutils

const FNames = ["patients1.csv",  "patients2.csv"]

proc createTableHeaders(conn: DbConn) =
    conn.exec(sql"CREATE TABLE names(PATIENT_ID INT, LASTNAME TEXT);")
    conn.exec(sql"CREATE TABLE visits(PATIENT_ID INT, VISIT_DATE DATE, SCORE NUMERIC(4,1));")


proc fillTables(dbc: DbConn) =
  for idx, fname in FNames:
    dbc.exec(sql"BEGIN")
    var parser: CsvParser
    parser.open(fname)
    parser.readHeaderRow()
    while parser.readRow():
      if idx == 0:  # "names" table.
        dbc.exec(sql"INSERT INTO names VALUES (?, ?);", parser.row)
      else:         # "visits" table
        dbc.exec(sql"INSERT INTO visits VALUES (?, ?, ?);", parser.row)
    dbc.exec(sql"COMMIT")


proc joinTablesAndGroup(dbc: DbConn): seq[Row] =
  dbc.exec(sql"""CREATE TABLE answer AS
                   SELECT
                     names.PATIENT_ID,
                     names.LASTNAME,
                     MAX(VISIT_DATE) AS LAST_VISIT,
                     SUM(SCORE) AS SCORE_SUM,
                     CAST(AVG(SCORE) AS DECIMAL(10,2)) AS SCORE_AVG
                   FROM
                     names
                     LEFT JOIN visits
                       ON visits.PATIENT_ID = names.PATIENT_ID
                   GROUP BY
                     names.PATIENT_ID,
                     names.LASTNAME
                   ORDER BY
                     names.PATIENT_ID;""")
  result = dbc.getAllRows(sql"SELECT * FROM ANSWER")

# Build the database and execute the request to get the result.
let dbc = open(":memory:", "", "", "")
dbc.createTableHeaders()
dbc.fillTables()
let result = dbc.joinTablesAndGroup()
dbc.close()

# Print the result.
echo "| PATIENT_ID |  LASTNAME  | LAST_VISIT |  SCORE_SUM | SCORE_AVG |"
for row in result:
  echo "| " & row.mapit(it.center(10)).join(" | ") & '|'
