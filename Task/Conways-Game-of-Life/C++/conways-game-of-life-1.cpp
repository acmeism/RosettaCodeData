#include <iostream>
#include <vector>
#include <SFML/Graphics.hpp>
#include <thread>
#include <chrono>
using namespace std;

class Life {
    private:
        int ticks;
        bool pass;
        int height;
        int width;
        bool **board;
        bool **buffer;
        vector<pair<float,float>> liveCoords;
        void init();
        void lives(int x, int y);
        void dies(int x, int y);
        bool isAlive(bool **curr, int x, int y);
        int checkNeighbors(bool **curr, int x, int y);
        void evaluatePosition(bool** curr, int x, int y);
    public:
        Life(int w = 100, int h = 50, int seed = 1337);
        Life(const Life& life);
        ~Life();
        vector<pair<float,float>> doTick();
        Life& operator=(const Life& life);
};
void Life::init() {
    board = new bool*[height];
    buffer = new bool*[height];
    for (int y = 0; y < height; y++) {
        board[y] = new bool[width];
        buffer[y] = new bool[width];
        for (int x = 0; x < width; x++) {
            board[y][x] = false;
            buffer[y][x] = false;
        }
    }
}

Life::Life(int w, int h, int seed) {
    width = w;
    height = h;
    init();
    for (int i = 0; i < seed; i++) {
        board[rand() % height][rand() % width] = true;
    }
    pass = true;
}

Life::Life(const Life& life) {
    width = life.width;
    height = life.height;
    init();
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            board[y][x] = life.board[y][x];
            buffer[y][x] = life.buffer[y][x];
        }
    }
}

Life& Life::operator=(const Life& life) {
    width = life.width;
    height = life.height;
    init();
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            board[y][x] = life.board[y][x];
            buffer[y][x] = life.buffer[y][x];
        }
    }
    return *this;
}

Life::~Life() {
    for (int i = 0; i < height; i++) {
        delete [] board[i];
        delete [] buffer[i];
    }
    delete [] board;
    delete [] buffer;
}

vector<pair<float,float>> Life::doTick() {
    liveCoords.clear();
    bool **currentGeneration = pass ? board:buffer;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            evaluatePosition(currentGeneration, x, y);
        }
    }
    pass = !pass;
    ticks++;
    return liveCoords;
}


bool Life::isAlive(bool **curr, int x, int y) {
    return curr[y][x];
}
int Life::checkNeighbors(bool **curr, int x, int y) {
    int lc = 0;
    int dx[8] = {-1, 0, 1,1,1,-1, 0,-1};
    int dy[8] = {-1,-1,-1,0,1, 1, 1, 0};
    for (int i = 0; i < 8; i++) {
        int nx = ((dx[i]+x)+width) % width;
        int ny = ((dy[i]+y)+height) % height;
        lc += isAlive(curr, nx, ny);
    }
    return lc;
}
void Life::lives(int x, int y) {
    if (!pass) {
        board[y][x] = true;
    } else {
        buffer[y][x] = true;
    }
    liveCoords.push_back(make_pair((float)x,(float)y));
}
void Life::dies(int x, int y) {
    if (!pass) {
        board[y][x] = false;
    } else {
        buffer[y][x] = false;
    }
}
void Life::evaluatePosition(bool** generation, int x, int y) {
    int lc = checkNeighbors(generation, x, y);
    if (isAlive(generation, x, y)) {
        if (lc == 2 || lc == 3) {
            lives(x, y);
        } else {
            dies(x, y);
        }
    } else {
        if (lc == 3) {
            lives(x, y);
        } else {
            dies(x, y);
        }
    }
}

class App {
    private:
        void sleep();
        void drawLiveCells();
        void render();
        void handleEvent(sf::Event& event);
        void saveDisplay();
        int width;
        int height;
        Life life;
        bool isRecording;
        int tick;
        sf::RenderWindow* window;
        sf::RenderTexture* texture;
    public:
        App(int w = 100, int h = 50);
        void start();
};

App::App(int w, int h) {
    height = h;
    width = w;
    life = Life(width, height);
    isRecording = false;
    tick = 0;
}

void App::start() {
    sf::Event event;
    window = new sf::RenderWindow(sf::VideoMode(width*10, height*10), "The Game of Life");
    texture = new sf::RenderTexture();
    texture->create(width*10, height*10);
    window->setFramerateLimit(60);
    while (window->isOpen()) {
        while (window->pollEvent(event)) {
            handleEvent(event);
        }
        render();
        tick++;
    }
    delete window;
    delete texture;
}

void App::handleEvent(sf::Event& event) {
    if (event.type == sf::Event::Closed) {
        window->close();
    }
    if (event.type == sf::Event::KeyPressed) {
        switch (event.key.code) {
            case sf::Keyboard::R:
                life = Life(width, height);
                break;
            case sf::Keyboard::S:
                isRecording = !isRecording;
                break;
            case sf::Keyboard::Q:
            case sf::Keyboard::Escape:
                window->close();
                break;
            default:
                break;
        }
    }
}

void App::sleep() {
    std::this_thread::sleep_for(350ms);
}

void App::drawLiveCells() {

    float XSCALE = 10.0, YSCALE = 10.0;
    sf::RectangleShape rect;
    rect.setSize(sf::Vector2f(XSCALE, YSCALE));
    rect.setFillColor(sf::Color::Green);
    auto coords = life.doTick();
    texture->clear(sf::Color::Black);
    for (auto m : coords) {
        rect.setPosition(m.first*XSCALE, m.second*YSCALE);
        texture->draw(rect);
    }
    texture->display();
}

void App::render() {
    drawLiveCells();
    window->clear();
    sf::Sprite sprite(texture->getTexture());
    window->draw(sprite);
    window->display();
    if (isRecording) saveDisplay();
    sleep();
}

void App::saveDisplay() {
    string name = "tick" + to_string(tick) + ".png";
    sf::Image image = texture->getTexture().copyToImage();
    image.saveToFile(name);
}

int main(int argc, char* argv[]) {
    srand(time(0));
    App app;
    app.start();
    return 0;
}
