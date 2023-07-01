#include <iostream>
#include <random>
#include <vector>

#include <QImage>

bool barnsleyFern(const char* fileName, int width, int height) {
    constexpr int iterations = 1000000;
    int bytesPerLine = 4 * ((width + 3)/4);
    std::vector<uchar> imageData(bytesPerLine * height);

    std::random_device dev;
    std::mt19937 engine(dev());
    std::uniform_int_distribution<int> distribution(1, 100);

    double x = 0, y = 0;
    for (int i = 0; i < iterations; ++i) {
        int r = distribution(engine);
        double x1, y1;
        if (r == 1) {
            x1 = 0;
            y1 = 0.16 * y;
        } else if (r <= 86) {
            x1 = 0.85 * x + 0.04 * y;
            y1 = -0.04 * x + 0.85 * y + 1.6;
        } else if (r <= 93) {
            x1 = 0.2 * x - 0.26 * y;
            y1 = 0.23 * x + 0.22 * y + 1.6;
        } else {
            x1 = -0.15 * x + 0.28 * y;
            y1 = 0.26 * x + 0.24 * y + 0.44;
        }
        x = x1;
        y = y1;
        int row = height * (1 - y/11);
        int column = width * (0.5 + x/11);
        imageData[row * bytesPerLine + column] = 1;
    }

    QImage image(&imageData[0], width, height, bytesPerLine, QImage::Format_Indexed8);
    QVector<QRgb> colours(2);
    colours[0] = qRgb(255, 255, 255);
    colours[1] = qRgb(0, 160, 0);
    image.setColorTable(colours);
    return image.save(fileName);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        std::cerr << "usage: " << argv[0] << " filename\n";
        return EXIT_FAILURE;
    }
    if (!barnsleyFern(argv[1], 600, 600)) {
        std::cerr << "image generation failed\n";
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
