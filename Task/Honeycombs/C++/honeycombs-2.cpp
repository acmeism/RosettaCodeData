//
// honeycombwidget.cpp
//
#include "honeycombwidget.h"
#include <QtWidgets>
#include <algorithm>
#include <cmath>
#include <numeric>
#include <random>

HoneycombWidget::HoneycombWidget(QWidget *parent)
    : QWidget(parent) {
    setWindowTitle(tr("Honeycombs"));

    const int rows = 4;
    const int columns = 5;
    const int margin = 15;
    const int cellWidth = 90;

    std::random_device dev;
    std::mt19937 engine(dev());
    char letters[26];
    std::iota(std::begin(letters), std::end(letters), 0);
    std::shuffle(std::begin(letters), std::end(letters), engine);

    const double pi = 3.14159265358979323846264338327950288;
    double x = cellWidth * std::sin(pi/6), y = cellWidth * std::cos(pi/6);
    double cx = margin + cellWidth/2;
    int i = 0;
    for (int column = 0; column < columns; ++column) {
        double cy = margin + y/2;
        if (column % 2 == 1)
            cy += y/2;
        for (int row = 0; row < rows; ++row) {
            QPolygon polygon(7);
            polygon.setPoint(0, cx + x/2, cy - y/2);
            polygon.setPoint(1, cx + cellWidth/2, cy);
            polygon.setPoint(2, cx + x/2, cy + y/2);
            polygon.setPoint(3, cx - x/2, cy + y/2);
            polygon.setPoint(4, cx - cellWidth/2, cy);
            polygon.setPoint(5, cx - x/2, cy - y/2);
            polygon.setPoint(6, cx + x/2, cy - y/2);
            int c = letters[i++];
            cells.push_back(Cell(polygon, Qt::Key_A + c, 'A' + c));
            cy += y;
        }
        cx += (x + cellWidth)/2;
    }
    int totalHeight = margin * 2 + y/2 + rows * y;
    int totalWidth = margin * 2 + cellWidth + (columns-1) * (x + cellWidth)/2;
    resize(totalWidth, totalHeight);
}

void HoneycombWidget::paintEvent(QPaintEvent *event) {
    const QColor backgroundColor(255, 255, 255);
    const QColor borderColor(0, 0, 0);
    const QColor cellColor(255, 255, 0);
    const QColor textColor(255, 0, 0);
    const QColor selectedCellColor(255, 0, 255);
    const QColor selectedTextColor(0, 0, 0);

    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing);
    painter.fillRect(event->rect(), backgroundColor);
    QFont font("Helvetica");
    font.setPixelSize(40);
    painter.setFont(font);
    for (const Cell& cell : cells) {
        QPainterPath path;
        path.addPolygon(cell.polygon);
        QPen pen(borderColor, 3);
        painter.setPen(pen);
        painter.setBrush(cell.selected ? selectedCellColor : cellColor);
        painter.drawPath(path);
        painter.setPen(cell.selected ? selectedTextColor : textColor);
        painter.drawText(cell.polygon.boundingRect(),
                         Qt::AlignCenter, QString(cell.character));
    }
}

void HoneycombWidget::mouseReleaseEvent(QMouseEvent *event) {
    QPoint point = event->pos();
    auto cell = std::find_if(cells.begin(), cells.end(),
        [point](const Cell& c) {
            return c.polygon.containsPoint(point, Qt::OddEvenFill);
    });
    if (cell != cells.end() && !cell->selected) {
        cell->selected = true;
        update(cell->polygon.boundingRect());
    }
}

void HoneycombWidget::keyPressEvent(QKeyEvent *event) {
    int key = event->key();
    auto cell = std::find_if(cells.begin(), cells.end(),
        [key](const Cell& c) { return c.letter == key; });
    if (cell != cells.end() && !cell->selected) {
        cell->selected = true;
        update(cell->polygon.boundingRect());
    }
}
