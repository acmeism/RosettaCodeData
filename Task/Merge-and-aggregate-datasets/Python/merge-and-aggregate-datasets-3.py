import sqlite3
import csv


fnames = 'patients.csv  patients_visits.csv'.split()
conn = sqlite3.connect(":memory:")
#%%

def create_table_headers(conn):
    curs = conn.cursor()
    curs.execute('''
      CREATE TABLE patients(PATIENT_ID INT, LASTNAME TEXT);
    ''')
    curs.execute('''
      CREATE TABLE patients_visits(PATIENT_ID INT, VISIT_DATE DATE, SCORE NUMERIC(4,1));
    ''')
    conn.commit()

def fill_tables(conn, fnames):
    curs = conn.cursor()
    for fname in fnames:
        with open(fname) as f:
            tablename = fname.replace('.csv', '')
            #
            csvdata = csv.reader(f)
            header = next(csvdata)
            fields = ','.join('?' for _ in header)
            for row in csvdata:
                row = [(None if r == '' else r) for r in row]
                curs.execute(f"INSERT INTO {tablename} VALUES ({fields});", row)
    conn.commit()

def join_tables_and_group(conn):
    curs = conn.cursor()
    curs.execute('''
CREATE TABLE answer AS
    SELECT
    	patients.PATIENT_ID,
    	patients.LASTNAME,
    	MAX(VISIT_DATE) AS LAST_VISIT,
    	SUM(SCORE) AS SCORE_SUM,
    	CAST(AVG(SCORE) AS DECIMAL(10,2)) AS SCORE_AVG
    FROM
    	patients
    	LEFT JOIN patients_visits
    		ON patients_visits.PATIENT_ID = patients.PATIENT_ID
    GROUP BY
    	patients.PATIENT_ID,
    	patients.LASTNAME
    ORDER BY
    	patients.PATIENT_ID;
        ''')
    curs.execute('''
SELECT * FROM answer;
        ''')
    conn.commit()
    rows = list(curs.fetchall())
    headers = tuple(d[0] for d in curs.description)
    return [headers] + rows

create_table_headers(conn)
fill_tables(conn, fnames)
result = join_tables_and_group(conn)
for record in result:
    print(f"| {' | '.join(f'{str(r):^10}' for r in record)} |")
