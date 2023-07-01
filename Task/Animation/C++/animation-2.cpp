#ifndef ANIMATIONWIDGET_H
#define ANIMATIONWIDGET_H

#include <QWidget>

class AnimationWidget : public QWidget {
    Q_OBJECT
public:
    AnimationWidget(QWidget *parent = nullptr);
protected:
    void mousePressEvent(QMouseEvent *event) override;
private:
    bool right_ = true;
};

#endif // ANIMATIONWIDGET_H
