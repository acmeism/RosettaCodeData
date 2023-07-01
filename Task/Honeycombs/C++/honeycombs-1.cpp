//
// honeycombwidget.h
//
#ifndef HONEYCOMBWIDGET_H
#define HONEYCOMBWIDGET_H

#include <QWidget>
#include <vector>

class HoneycombWidget : public QWidget {
    Q_OBJECT
public:
    HoneycombWidget(QWidget *parent = nullptr);
protected:
    void paintEvent(QPaintEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void keyPressEvent(QKeyEvent *event) override;
private:
    struct Cell {
        Cell(const QPolygon& p, int l, char ch)
            : polygon(p), letter(l), character(ch), selected(false) {}
        QPolygon polygon;
        int letter;
        char character;
        bool selected;
    };
    std::vector<Cell> cells;
};

#endif // HONEYCOMBWIDGET_H
