#include <stdio.h>
#include <stdlib.h>
#include <sqlite3.h>

static const char* db_file = ":memory:"; // Create an in-memory database.

void check_error(int result_code, sqlite3 *db);
int select_callback(void* data, int column_count, char** columns, char** column_names);

int main(void) {
    sqlite3 *db;
    int result_code;
    char *sql;
    char *insert_statements[4];
    sqlite3_stmt *compiled_statement;
    int i;

    // Open the database.
    result_code = sqlite3_open(db_file, &db);
    check_error(result_code, db);

    // Create the players table in the database.
    sql = "create table players("
          "id integer primary key asc, "
          "name text, "
          "score real, "
          "active integer, " // Store the bool value as integer (see https://sqlite.org/datatype3.html chapter 2.1).
          "jerseyNum integer);";
    result_code = sqlite3_exec(db, sql, NULL, NULL, NULL);
    check_error(result_code, db);

    // Insert some values into the players table.
    insert_statements[0] = "insert into players (name, score, active, jerseyNum) "
                                        "values ('Roethlisberger, Ben', 94.1, 1, 7);";
    insert_statements[1] = "insert into players (name, score, active, jerseyNum) "
                                        "values ('Smith, Alex', 85.3, 1, 11);";
    insert_statements[2] = "insert into players (name, score, active, jerseyNum) "
                                        "values ('Manning, Payton', 96.5, 0, 18);";
    insert_statements[3] = "insert into players (name, score, active, jerseyNum) "
                                        "values ('Doe, John', 15, 0, 99);";

    for (i=0; i<4; i++) {
        result_code = sqlite3_exec(db, insert_statements[i], NULL, NULL, NULL);
        check_error(result_code, db);
    }

    // Display the contents of the players table.
    printf("Before update:\n");
    sql = "select * from players;";
    result_code = sqlite3_exec(db, sql, select_callback, NULL, NULL);
    check_error(result_code, db);

    // Prepare the parametrized SQL statement to update player #99.
    sql = "update players set name=?, score=?, active=? where jerseyNum=?;";
    result_code = sqlite3_prepare_v2(db, sql, -1, &compiled_statement, NULL);
    check_error(result_code, db);

    // Bind the values to the parameters (see https://sqlite.org/c3ref/bind_blob.html).
    result_code = sqlite3_bind_text(compiled_statement, 1, "Smith, Steve", -1, NULL);
    check_error(result_code, db);
    result_code = sqlite3_bind_double(compiled_statement, 2, 42);
    check_error(result_code, db);
    result_code = sqlite3_bind_int(compiled_statement, 3, 1);
    check_error(result_code, db);
    result_code = sqlite3_bind_int(compiled_statement, 4, 99);
    check_error(result_code, db);

    // Evaluate the prepared SQL statement.
    result_code = sqlite3_step(compiled_statement);
    if (result_code != SQLITE_DONE) {
        printf("Error #%d: %s\n", result_code, sqlite3_errmsg(db));
        sqlite3_close(db);
        return result_code;
    }

    // Destroy the prepared statement object.
    result_code = sqlite3_finalize(compiled_statement);
    check_error(result_code, db);

    // Display the contents of the players table.
    printf("After update:\n");
    sql = "select * from players;";
    result_code = sqlite3_exec(db, sql, select_callback, NULL, NULL);
    check_error(result_code, db);

    // Close the database connection.
    sqlite3_close(db);

    return EXIT_SUCCESS;
}

/*
  Checks the result code from an SQLite operation.
  If it contains an error code then this function prints the error message,
  closes the database and exits.
*/
void check_error(int result_code, sqlite3 *db) {
    if (result_code != SQLITE_OK) {
        printf("Error #%d: %s\n", result_code, sqlite3_errmsg(db));
        sqlite3_close(db);
        exit(result_code);
    }
}

/* This callback function prints the results of the select statement. */
int select_callback(void* data, int column_count, char** columns, char** column_names) {
    int i;

    for (i=0; i<column_count; i++) {
        printf(columns[i]);
        if (i < column_count-1) printf(" | ");
    }
    printf("\n");
}
