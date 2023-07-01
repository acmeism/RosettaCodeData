#include <QApplication>
#include <QWidget>
#include <QVBoxLayout>
#include <QPushButton>
#include <QLineEdit>
#include <QIntValidator>
#include <QMessageBox>
#include <QTime>

int main(int argc, char **argv) {
    qsrand(QTime::currentTime().msec());

    QApplication app(argc, argv);

    auto *edit = new QLineEdit("0");
    edit->setValidator(new QIntValidator());

    auto *incButton = new QPushButton("&Increment");
    QObject::connect(incButton, &QPushButton::clicked,
            [edit]() { edit->setText( QString::number(edit->text().toInt() + 1)); } );

    auto *rndButton = new QPushButton("&Random");
    QObject::connect(rndButton, &QPushButton::clicked,
            [edit]() {
                auto result = QMessageBox(
                    QMessageBox::Warning,
                    "Random",
                    "Overwrite current value with a random number ?",
                    QMessageBox::Ok | QMessageBox::Cancel
                ).exec();

                if (result == QMessageBox::Ok)
                    edit->setText( QString::number(qrand()));
            } );

    auto *vbox = new QVBoxLayout;
    vbox->addWidget(edit);
    vbox->addWidget(incButton);
    vbox->addWidget(rndButton);

    QWidget mainWindow;
    mainWindow.setLayout(vbox);
    mainWindow.show();

    return app.exec();
}
