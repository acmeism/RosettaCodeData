//
// main.cpp
//
#include <QApplication>
#include "honeycombwidget.h"

int main(int argc, char *argv[]) {
    QApplication a(argc, argv);
    HoneycombWidget w;
    w.show();
    return a.exec();
}
