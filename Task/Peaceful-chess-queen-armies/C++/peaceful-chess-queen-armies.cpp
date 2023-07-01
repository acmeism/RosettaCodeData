#include <iostream>
#include <vector>

enum class Piece {
    empty,
    black,
    white
};

typedef std::pair<int, int> position;

bool isAttacking(const position &queen, const position &pos) {
    return queen.first == pos.first
        || queen.second == pos.second
        || abs(queen.first - pos.first) == abs(queen.second - pos.second);
}

bool place(const int m, const int n, std::vector<position> &pBlackQueens, std::vector<position> &pWhiteQueens) {
    if (m == 0) {
        return true;
    }
    bool placingBlack = true;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            auto pos = std::make_pair(i, j);
            for (auto queen : pBlackQueens) {
                if (queen == pos || !placingBlack && isAttacking(queen, pos)) {
                    goto inner;
                }
            }
            for (auto queen : pWhiteQueens) {
                if (queen == pos || placingBlack && isAttacking(queen, pos)) {
                    goto inner;
                }
            }
            if (placingBlack) {
                pBlackQueens.push_back(pos);
                placingBlack = false;
            } else {
                pWhiteQueens.push_back(pos);
                if (place(m - 1, n, pBlackQueens, pWhiteQueens)) {
                    return true;
                }
                pBlackQueens.pop_back();
                pWhiteQueens.pop_back();
                placingBlack = true;
            }

        inner: {}
        }
    }
    if (!placingBlack) {
        pBlackQueens.pop_back();
    }
    return false;
}

void printBoard(int n, const std::vector<position> &blackQueens, const std::vector<position> &whiteQueens) {
    std::vector<Piece> board(n * n);
    std::fill(board.begin(), board.end(), Piece::empty);

    for (auto &queen : blackQueens) {
        board[queen.first * n + queen.second] = Piece::black;
    }
    for (auto &queen : whiteQueens) {
        board[queen.first * n + queen.second] = Piece::white;
    }

    for (size_t i = 0; i < board.size(); ++i) {
        if (i != 0 && i % n == 0) {
            std::cout << '\n';
        }
        switch (board[i]) {
        case Piece::black:
            std::cout << "B ";
            break;
        case Piece::white:
            std::cout << "W ";
            break;
        case Piece::empty:
        default:
            int j = i / n;
            int k = i - j * n;
            if (j % 2 == k % 2) {
                std::cout << "x ";
            } else {
                std::cout << "* ";
            }
            break;
        }
    }

    std::cout << "\n\n";
}

int main() {
    std::vector<position> nms = {
        {2, 1}, {3, 1}, {3, 2}, {4, 1}, {4, 2}, {4, 3},
        {5, 1}, {5, 2}, {5, 3}, {5, 4}, {5, 5},
        {6, 1}, {6, 2}, {6, 3}, {6, 4}, {6, 5}, {6, 6},
        {7, 1}, {7, 2}, {7, 3}, {7, 4}, {7, 5}, {7, 6}, {7, 7},
    };

    for (auto nm : nms) {
        std::cout << nm.second << " black and " << nm.second << " white queens on a " << nm.first << " x " << nm.first << " board:\n";
        std::vector<position> blackQueens, whiteQueens;
        if (place(nm.second, nm.first, blackQueens, whiteQueens)) {
            printBoard(nm.first, blackQueens, whiteQueens);
        } else {
            std::cout << "No solution exists.\n\n";
        }
    }

    return 0;
}
