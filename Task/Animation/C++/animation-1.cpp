#include "animationwidget.h"

#include <QLabel>
#include <QTimer>
#include <QVBoxLayout>

#include <algorithm>

AnimationWidget::AnimationWidget(QWidget *parent) : QWidget(parent) {
    setWindowTitle(tr("Animation"));
    QFont font("Courier", 24);
    QLabel* label = new QLabel("Hello World! ");
    label->setFont(font);
    QVBoxLayout* layout = new QVBoxLayout(this);
    layout->addWidget(label);
    QTimer* timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, [label,this]() {
        QString text = label->text();
        std::rotate(text.begin(), text.begin() + (right_ ? text.length() - 1 : 1), text.end());
        label->setText(text);
    });
    timer->start(200);
}

void AnimationWidget::mousePressEvent(QMouseEvent*) {
    right_ = !right_;
}
