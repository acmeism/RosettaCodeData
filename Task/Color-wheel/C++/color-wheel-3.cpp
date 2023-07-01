// main.cpp
#include "colorwheelwidget.h"
#include <QApplication>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    ColorWheelWidget widget;
    widget.show();
    return app.exec();
}
