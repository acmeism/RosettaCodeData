// colorwheelwidget.cpp
#include "colorwheelwidget.h"
#include <QPainter>
#include <QPaintEvent>
#include <cmath>

namespace {

QColor hsvToRgb(int h, double s, double v) {
    double hp = h/60.0;
    double c = s * v;
    double x = c * (1 - std::abs(std::fmod(hp, 2) - 1));
    double m = v - c;
    double r = 0, g = 0, b = 0;
    if (hp <= 1) {
        r = c;
        g = x;
    } else if (hp <= 2) {
        r = x;
        g = c;
    } else if (hp <= 3) {
        g = c;
        b = x;
    } else if (hp <= 4) {
        g = x;
        b = c;
    } else if (hp <= 5) {
        r = x;
        b = c;
    } else {
        r = c;
        b = x;
    }
    r += m;
    g += m;
    b += m;
    return QColor(r * 255, g * 255, b * 255);
}

}

ColorWheelWidget::ColorWheelWidget(QWidget *parent)
    : QWidget(parent) {
    setWindowTitle(tr("Color Wheel"));
    resize(400, 400);
}

void ColorWheelWidget::paintEvent(QPaintEvent *event) {
    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing);
    const QColor backgroundColor(0, 0, 0);
    const QColor white(255, 255, 255);
    painter.fillRect(event->rect(), backgroundColor);
    const int margin = 10;
    const double diameter = std::min(width(), height()) - 2*margin;
    QPointF center(width()/2.0, height()/2.0);
    QRectF rect(center.x() - diameter/2.0, center.y() - diameter/2.0,
                diameter, diameter);
    for (int angle = 0; angle < 360; ++angle) {
        QColor color(hsvToRgb(angle, 1.0, 1.0));
        QRadialGradient gradient(center, diameter/2.0);
        gradient.setColorAt(0, white);
        gradient.setColorAt(1, color);
        QBrush brush(gradient);
        QPen pen(brush, 1.0);
        painter.setPen(pen);
        painter.setBrush(brush);
        painter.drawPie(rect, angle * 16, 16);
    }
}
