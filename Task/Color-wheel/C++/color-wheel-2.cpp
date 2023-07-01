// colorwheelwidget.h
#ifndef COLORWHEELWIDGET_H
#define COLORWHEELWIDGET_H

#include <QWidget>

class ColorWheelWidget : public QWidget {
    Q_OBJECT
public:
    ColorWheelWidget(QWidget *parent = nullptr);
protected:
    void paintEvent(QPaintEvent *event) override;
};

#endif // COLORWHEELWIDGET_H
