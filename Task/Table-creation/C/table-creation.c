#include <sqlite3.h>
#include <stdlib.h>
#include <stdio.h>

int main()
{
  sqlite3 *db = NULL;
  char *errmsg;

	const char *code =
	"CREATE TABLE employee (\n"
	"    empID		INTEGER PRIMARY KEY AUTOINCREMENT,\n"
	"	firstName	TEXT NOT NULL,\n"
	"	lastName	TEXT NOT NULL,\n"
	"	AGE			INTEGER NOT NULL,\n"
	"	DOB			DATE NOT NULL)\n" ;
	
  if ( sqlite3_open("employee.db", &db) == SQLITE_OK ) {
    sqlite3_exec(db, code, NULL, NULL,  &errmsg);
    sqlite3_close(db);
  } else {
    fprintf(stderr, "cannot open db...\n");
    sqlite3_close(db);
    exit(EXIT_FAILURE);
  }
  return 0;
}
