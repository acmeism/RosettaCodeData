#include <SDL2/SDL.h>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <iostream>
#include <memory>
#include <random>
#include <tuple>
#include <vector>

auto now() {
    using namespace std::chrono;
    auto time = system_clock::now();
    return duration_cast<milliseconds>(time.time_since_epoch()).count();
}

auto hsv_to_rgb(int h, double s, double v) {
    double hp = h / 60.0;
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
    return std::make_tuple(Uint8(r * 255), Uint8(g * 255), Uint8(b * 255));
}

class ParticleFountain {
public:
    ParticleFountain(int particles, int width, int height);
    void run();

private:
    struct WindowDeleter {
        void operator()(SDL_Window* window) const { SDL_DestroyWindow(window); }
    };
    struct RendererDeleter {
        void operator()(SDL_Renderer* renderer) const {
            SDL_DestroyRenderer(renderer);
        }
    };
    struct PointInfo {
        double x = 0;
        double y = 0;
        double vx = 0;
        double vy = 0;
        double lifetime = 0;
    };

    void update(double df);
    bool handle_event();
    void render();
    double rand() { return dist_(rng_); }
    double reciprocate() const {
        return reciprocate_ ? range_ * std::sin(now() / 1000.0) : 0.0;
    }

    std::unique_ptr<SDL_Window, WindowDeleter> window_;
    std::unique_ptr<SDL_Renderer, RendererDeleter> renderer_;
    int width_;
    int height_;
    std::vector<PointInfo> point_info_;
    std::vector<SDL_Point> points_;
    int num_points_ = 0;
    double saturation_ = 0.4;
    double spread_ = 1.5;
    double range_ = 1.5;
    bool reciprocate_ = false;
    std::mt19937 rng_;
    std::uniform_real_distribution<> dist_;
};

ParticleFountain::ParticleFountain(int n, int width, int height)
    : width_(width), height_(height), point_info_(n), points_(n, {0, 0}),
      rng_(std::random_device{}()), dist_(0.0, 1.0) {
    window_.reset(SDL_CreateWindow(
        "C++ Particle System!", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        width, height, SDL_WINDOW_RESIZABLE));
    if (window_ == nullptr)
        throw std::runtime_error(SDL_GetError());

    renderer_.reset(
        SDL_CreateRenderer(window_.get(), -1, SDL_RENDERER_ACCELERATED));
    if (renderer_ == nullptr)
        throw std::runtime_error(SDL_GetError());
}

void ParticleFountain::run() {
    for (double df = 0.0001;;) {
        auto start = now();
        if (!handle_event())
            break;
        update(df);
        render();
        df = (now() - start) / 1000.0;
    }
}

void ParticleFountain::update(double df) {
    int pointidx = 0;
    for (PointInfo& point : point_info_) {
        bool willdraw = false;
        if (point.lifetime <= 0.0) {
            if (rand() < df) {
                point.lifetime = 2.5;
                point.x = width_ / 20.0;
                point.y = height_ / 10.0;
                point.vx =
                    (spread_ * rand() - spread_ / 2 + reciprocate()) * 10.0;
                point.vy = (rand() - 2.9) * height_ / 20.5;
                willdraw = true;
            }
        } else {
            if (point.y > height_ / 10.0 && point.vy > 0)
                point.vy *= -0.3;
            point.vy += (height_ / 10.0) * df;
            point.x += point.vx * df;
            point.y += point.vy * df;
            point.lifetime -= df;
            willdraw = true;
        }
        if (willdraw) {
            points_[pointidx].x = std::floor(point.x * 10.0);
            points_[pointidx].y = std::floor(point.y * 10.0);
            ++pointidx;
        }
    }
    num_points_ = pointidx;
}

bool ParticleFountain::handle_event() {
    bool result = true;
    SDL_Event event;
    while (result && SDL_PollEvent(&event)) {
        switch (event.type) {
        case SDL_QUIT:
            result = false;
            break;
        case SDL_WINDOWEVENT:
            if (event.window.event == SDL_WINDOWEVENT_RESIZED) {
                width_ = event.window.data1;
                height_ = event.window.data2;
            }
            break;
        case SDL_KEYDOWN:
            switch (event.key.keysym.scancode) {
            case SDL_SCANCODE_UP:
                saturation_ = std::min(saturation_ + 0.1, 1.0);
                break;
            case SDL_SCANCODE_DOWN:
                saturation_ = std::max(saturation_ - 0.1, 0.0);
                break;
            case SDL_SCANCODE_PAGEUP:
                spread_ = std::min(spread_ + 0.1, 5.0);
                break;
            case SDL_SCANCODE_PAGEDOWN:
                spread_ = std::max(spread_ - 0.1, 0.2);
                break;
            case SDL_SCANCODE_RIGHT:
                range_ = std::min(range_ + 0.1, 2.0);
                break;
            case SDL_SCANCODE_LEFT:
                range_ = std::max(range_ - 0.1, 0.1);
                break;
            case SDL_SCANCODE_SPACE:
                reciprocate_ = !reciprocate_;
                break;
            case SDL_SCANCODE_Q:
                result = false;
                break;
            default:
                break;
            }
            break;
        }
    }
    return result;
}

void ParticleFountain::render() {
    SDL_Renderer* renderer = renderer_.get();
    SDL_SetRenderDrawColor(renderer, 0x0, 0x0, 0x0, 0xff);
    SDL_RenderClear(renderer);
    auto [red, green, blue] = hsv_to_rgb((now() % 5) * 72, saturation_, 1);
    SDL_SetRenderDrawColor(renderer, red, green, blue, 0x7f);
    SDL_RenderDrawPoints(renderer, points_.data(), num_points_);
    SDL_RenderPresent(renderer);
}

int main() {
    std::cout << "Use UP and DOWN arrow keys to modify the saturation of the "
                 "particle colors.\n"
                 "Use PAGE UP and PAGE DOWN keys to modify the \"spread\" of "
                 "the particles.\n"
                 "Toggle reciprocation off / on with the SPACE bar.\n"
                 "Use LEFT and RIGHT arrow keys to modify angle range for "
                 "reciprocation.\n"
                 "Press the \"q\" key to quit.\n";

    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        std::cerr << "ERROR: " << SDL_GetError() << '\n';
        return EXIT_FAILURE;
    }

    try {
        ParticleFountain pf(3000, 800, 800);
        pf.run();
    } catch (const std::exception& ex) {
        std::cerr << "ERROR: " << ex.what() << '\n';
        SDL_Quit();
        return EXIT_FAILURE;
    }

    SDL_Quit();
    return EXIT_SUCCESS;
}
