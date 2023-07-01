// Based on https://www.cairographics.org/samples/gradient/

#include <QImage>
#include <QPainter>

int main() {
    const QColor black(0, 0, 0);
    const QColor white(255, 255, 255);

    const int size = 300;
    const double diameter = 0.6 * size;

    QImage image(size, size, QImage::Format_RGB32);
    QPainter painter(&image);
    painter.setRenderHint(QPainter::Antialiasing);

    QLinearGradient linearGradient(0, 0, 0, size);
    linearGradient.setColorAt(0, white);
    linearGradient.setColorAt(1, black);

    QBrush brush(linearGradient);
    painter.fillRect(QRect(0, 0, size, size), brush);

    QPointF point1(0.4 * size, 0.4 * size);
    QPointF point2(0.45 * size, 0.4 * size);
    QRadialGradient radialGradient(point1, size * 0.5, point2, size * 0.1);
    radialGradient.setColorAt(0, white);
    radialGradient.setColorAt(1, black);

    QBrush brush2(radialGradient);
    painter.setPen(Qt::NoPen);
    painter.setBrush(brush2);
    painter.drawEllipse(QRectF((size - diameter)/2, (size - diameter)/2, diameter, diameter));

    image.save("sphere.png");
    return 0;
}
