#include "animationwidget.h"

#include <QApplication>

int main(int argc, char *argv[]) {
    QApplication a(argc, argv);
    AnimationWidget w;
    w.show();
    return a.exec();
}
