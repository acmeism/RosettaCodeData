#ifndef PROCESSING_FLOODFILLALGORITHM_H_
#define PROCESSING_FLOODFILLALGORITHM_H_

#include <opencv2/opencv.hpp>
#include <string.h>
#include <queue>

using namespace cv;
using namespace std;

class FloodFillAlgorithm {
public:
    FloodFillAlgorithm(Mat* image) :
        image(image) {
    }
    virtual ~FloodFillAlgorithm();

    void flood(Point startPoint, Scalar tgtColor, Scalar loDiff);
    void flood(Point startPoint, Mat* tgtMat);

protected:
    Mat* image;
private:
    bool insideImage(Point p);
};

#endif /* PROCESSING_FLOODFILLALGORITHM_H_ */
