#include <iostream>
#include <string>
#include <sstream>
#include <valarray>
const std::string input {
"................................"
".#########.......########......."
".###...####.....####..####......"
".###....###.....###....###......"
".###...####.....###............."
".#########......###............."
".###.####.......###....###......"
".###..####..###.####..####.###.."
".###...####.###..########..###.."
"................................"
};
const std::string input2 {
".........................................................."
".#################...................#############........"
".##################...............################........"
".###################............##################........"
".########.....#######..........###################........"
"...######.....#######.........#######.......######........"
"...######.....#######........#######......................"
"...#################.........#######......................"
"...################..........#######......................"
"...#################.........#######......................"
"...######.....#######........#######......................"
"...######.....#######........#######......................"
"...######.....#######.........#######.......######........"
".########.....#######..........###################........"
".########.....#######.######....##################.######."
".########.....#######.######......################.######."
".########.....#######.######.........#############.######."
".........................................................."
};

class ZhangSuen;

class Image {
public:
    friend class ZhangSuen;
    using pixel_t = char;
    static const pixel_t BLACK_PIX;
    static const pixel_t WHITE_PIX;

    Image(unsigned width = 1, unsigned height = 1)
    : width_{width}, height_{height}, data_( '\0', width_ * height_)
    {}
    Image(const Image& i) : width_{ i.width_}, height_{i.height_}, data_{i.data_}
    {}
    Image(Image&& i) : width_{ i.width_}, height_{i.height_}, data_{std::move(i.data_)}
    {}
    ~Image() = default;
    Image& operator=(const Image& i) {
        if (this != &i) {
            width_ = i.width_;
            height_ = i.height_;
            data_ = i.data_;
        }
        return *this;
    }
    Image& operator=(Image&& i) {
        if (this != &i) {
            width_ = i.width_;
            height_ = i.height_;
            data_ = std::move(i.data_);
        }
        return *this;
    }
    size_t idx(unsigned x, unsigned y) const noexcept { return y * width_ + x; }
    bool operator()(unsigned x, unsigned y) {
        return data_[idx(x, y)];
    }
    friend std::ostream& operator<<(std::ostream& o, const Image& i) {
        o << i.width_ << " x " << i.height_ << std::endl;
        size_t px = 0;
        for(const auto& e : i.data_) {
            o << (e?Image::BLACK_PIX:Image::WHITE_PIX);
            if (++px % i.width_ == 0)
                o << std::endl;
        }
        return o << std::endl;
    }
    friend std::istream& operator>>(std::istream& in, Image& img) {
        auto it = std::begin(img.data_);
        const auto end = std::end(img.data_);
        Image::pixel_t tmp;
        while(in && it != end) {
            in >> tmp;
            if (tmp != Image::BLACK_PIX && tmp != Image::WHITE_PIX)
                throw "Bad character found in image";
            *it = (tmp == Image::BLACK_PIX)?1:0;
            ++it;
        }
        return in;
    }
    unsigned width() const noexcept { return width_; }
    unsigned height() const noexcept { return height_; }
    struct Neighbours {
        // 9 2 3
        // 8 1 4
        // 7 6 5
        Neighbours(const Image& img, unsigned p1_x, unsigned p1_y)
        : img_{img}
        , p1_{img.idx(p1_x, p1_y)}
        , p2_{p1_ - img.width()}
        , p3_{p2_ + 1}
        , p4_{p1_ + 1}
        , p5_{p4_ + img.width()}
        , p6_{p5_ - 1}
        , p7_{p6_ - 1}
        , p8_{p1_ - 1}
        , p9_{p2_ - 1}
        {}
        const Image& img_;
        const Image::pixel_t& p1() const noexcept { return img_.data_[p1_]; }
        const Image::pixel_t& p2() const noexcept { return img_.data_[p2_]; }
        const Image::pixel_t& p3() const noexcept { return img_.data_[p3_]; }
        const Image::pixel_t& p4() const noexcept { return img_.data_[p4_]; }
        const Image::pixel_t& p5() const noexcept { return img_.data_[p5_]; }
        const Image::pixel_t& p6() const noexcept { return img_.data_[p6_]; }
        const Image::pixel_t& p7() const noexcept { return img_.data_[p7_]; }
        const Image::pixel_t& p8() const noexcept { return img_.data_[p8_]; }
        const Image::pixel_t& p9() const noexcept { return img_.data_[p9_]; }
        const size_t p1_, p2_, p3_, p4_, p5_, p6_, p7_, p8_, p9_;
    };
    Neighbours neighbours(unsigned x, unsigned y) const { return Neighbours(*this, x, y); }
private:
    unsigned height_ { 0 };
    unsigned width_ { 0 };
    std::valarray<pixel_t> data_;
};

constexpr const Image::pixel_t Image::BLACK_PIX = '#';
constexpr const Image::pixel_t Image::WHITE_PIX = '.';

class ZhangSuen {
public:

    // the number of transitions from white to black, (0 -> 1) in the sequence P2,P3,P4,P5,P6,P7,P8,P9,P2
    unsigned transitions_white_black(const Image::Neighbours& a) const {
        unsigned sum = 0;
        sum += (a.p9() == 0) && a.p2();
        sum += (a.p2() == 0) && a.p3();
        sum += (a.p3() == 0) && a.p4();
        sum += (a.p8() == 0) && a.p9();
        sum += (a.p4() == 0) && a.p5();
        sum += (a.p7() == 0) && a.p8();
        sum += (a.p6() == 0) && a.p7();
        sum += (a.p5() == 0) && a.p6();
        return sum;
    }

    // The number of black pixel neighbours of P1. ( = sum(P2 .. P9) )
    unsigned black_pixels(const Image::Neighbours& a) const {
        unsigned sum = 0;
        sum += a.p9();
        sum += a.p2();
        sum += a.p3();
        sum += a.p8();
        sum += a.p4();
        sum += a.p7();
        sum += a.p6();
        sum += a.p5();
        return sum;
    }
    const Image& operator()(const Image& img) {
        tmp_a_ = img;
        size_t changed_pixels = 0;
        do {
            changed_pixels = 0;
            // Step 1
            tmp_b_ = tmp_a_;
            for(size_t y = 1; y < tmp_a_.height() - 1; ++y) {
                for(size_t x = 1; x < tmp_a_.width() - 1; ++x) {
                    if (tmp_a_.data_[tmp_a_.idx(x, y)]) {
                        auto n = tmp_a_.neighbours(x, y);
                        auto bp = black_pixels(n);
                        if (bp >= 2 && bp <= 6) {
                            auto tr = transitions_white_black(n);
                            if (    tr == 1
                                && (n.p2() * n.p4() * n.p6() == 0)
                                && (n.p4() * n.p6() * n.p8() == 0)
                                ) {
                                tmp_b_.data_[n.p1_] = 0;
                                ++changed_pixels;
                            }
                        }
                    }
                }
            }
            // Step 2
            tmp_a_ = tmp_b_;
            for(size_t y = 1; y < tmp_b_.height() - 1; ++y) {
                for(size_t x = 1; x < tmp_b_.width() - 1; ++x) {
                    if (tmp_b_.data_[tmp_b_.idx(x, y)]) {
                        auto n = tmp_b_.neighbours(x, y);
                        auto bp = black_pixels(n);
                        if (bp >= 2 && bp <= 6) {
                            auto tr = transitions_white_black(n);
                            if (    tr == 1
                                && (n.p2() * n.p4() * n.p8() == 0)
                                && (n.p2() * n.p6() * n.p8() == 0)
                                ) {
                                tmp_a_.data_[n.p1_] = 0;
                                ++changed_pixels;
                            }
                        }
                    }
                }
            }
        } while(changed_pixels > 0);
        return tmp_a_;
    }
private:
    Image tmp_a_;
    Image tmp_b_;
};

int main(int argc, char const *argv[])
{
    using namespace std;
    Image img(32, 10);
    istringstream iss{input};
    iss >> img;
    cout << img;
    cout << "ZhangSuen" << endl;
    ZhangSuen zs;
    Image res = std::move(zs(img));
    cout << res << endl;

    Image img2(58,18);
    istringstream iss2{input2};
    iss2 >> img2;
    cout << img2;
    cout << "ZhangSuen with big image" << endl;
    Image res2 = std::move(zs(img2));
    cout << res2 << endl;
    return 0;
}
