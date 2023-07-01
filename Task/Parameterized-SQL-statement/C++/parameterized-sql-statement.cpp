#include <QtSql>
#include <iostream>

// Command line arguments: data-source user password
// Obviously in a real application the password would be obtained in a secure manner.

int main(int argc, char *argv[]) {
    if (argc != 4) {
        std::cerr << "Usage: " << argv[0] << " data-source user password\n";
        return 1;
    }
    QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");
    db.setDatabaseName(argv[1]);
    if (!db.open(argv[2], argv[3])) {
        auto error = db.lastError();
        std::cerr << "Cannot connect to data source: " << error.text().toStdString() << '\n';
    } else {
        std::cout << "Connected to data source.\n";
        QSqlQuery query(db);
        query.prepare("UPDATE players SET name = ?, score = ?, active = ? WHERE jerseyNum = ?");
        query.bindValue(0, "Smith, Steve");
        query.bindValue(1, 42);
        query.bindValue(2, true);
        query.bindValue(3, 99);
        if (!query.exec()) {
            auto error = db.lastError();
            std::cerr << "Cannot update database: " << error.text().toStdString() << '\n';
        } else {
            std::cout << "Update succeeded.\n";
        }
    }
    return 0;
}
