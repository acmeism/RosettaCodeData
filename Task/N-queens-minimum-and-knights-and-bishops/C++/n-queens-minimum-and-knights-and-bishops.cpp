#include <chrono>
#include <climits>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>


class ChessBoard {
private:
    std::vector<std::vector<bool>> board;
    std::vector<std::vector<size_t>> diag1;
    std::vector<std::vector<size_t>> diag2;
    std::vector<bool> diag1_lookup;
    std::vector<bool> diag2_lookup;
    size_t n;
    size_t min_count;
    std::string layout;

public:
    ChessBoard(size_t n, const std::string& piece) : n(n), min_count(SIZE_MAX) {
        board = std::vector<std::vector<bool>>(n, std::vector<bool>(n, false));

        if (piece != "K") {
            diag1 = std::vector<std::vector<size_t>>(n, std::vector<size_t>(n));
            diag2 = std::vector<std::vector<size_t>>(n, std::vector<size_t>(n));

            for (size_t i = 0; i < n; i++) {
                for (size_t j = 0; j < n; j++) {
                    diag1[i][j] = i + j;
                    diag2[i][j] = i + n - 1 - j;
                }
            }

            diag1_lookup = std::vector<bool>(2 * n - 1, false);
            diag2_lookup = std::vector<bool>(2 * n - 1, false);
        }
    }

    bool is_attacked(const std::string& piece, size_t row, size_t col) {
        if (piece == "Q") {
            // Check row and column
            for (size_t i = 0; i < n; i++) {
                if (board[i][col] || board[row][i]) {
                    return true;
                }
            }
            // Check diagonals
            if (diag1_lookup[diag1[row][col]] || diag2_lookup[diag2[row][col]]) {
                return true;
            }
        } else if (piece == "B") {
            // Check diagonals only
            if (diag1_lookup[diag1[row][col]] || diag2_lookup[diag2[row][col]]) {
                return true;
            }
        } else if (piece == "K") {
            // Check if current position is occupied
            if (board[row][col]) {
                return true;
            }

            // Check all knight moves
            int knight_moves[8][2] = {
                {2, -1}, {-2, -1}, {2, 1}, {-2, 1},
                {1, 2}, {-1, 2}, {1, -2}, {-1, -2}
            };

            for (int i = 0; i < 8; i++) {
                int new_row = static_cast<int>(row) + knight_moves[i][0];
                int new_col = static_cast<int>(col) + knight_moves[i][1];

                if (new_row >= 0 && new_row < static_cast<int>(n) &&
                    new_col >= 0 && new_col < static_cast<int>(n)) {
                    if (board[new_row][new_col]) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    bool attacks(const std::string& piece, size_t row, size_t col, size_t trow, size_t tcol) {
        if (piece == "Q") {
            return row == trow || col == tcol ||
                   std::abs(static_cast<int>(row) - static_cast<int>(trow)) ==
                   std::abs(static_cast<int>(col) - static_cast<int>(tcol));
        } else if (piece == "B") {
            return std::abs(static_cast<int>(row) - static_cast<int>(trow)) ==
                   std::abs(static_cast<int>(col) - static_cast<int>(tcol));
        } else if (piece == "K") {
            int rd = std::abs(static_cast<int>(trow) - static_cast<int>(row));
            int cd = std::abs(static_cast<int>(tcol) - static_cast<int>(col));
            return (rd == 1 && cd == 2) || (rd == 2 && cd == 1);
        }
        return false;
    }

    void store_layout(const std::string& piece) {
        layout.clear();
        for (const auto& row : board) {
            for (bool cell : row) {
                if (cell) {
                    layout += piece + " ";
                } else {
                    layout += ". ";
                }
            }
            layout += "\n";
        }
    }

    void place_piece(const std::string& piece, size_t count_so_far, size_t max_count) {
        if (count_so_far >= min_count) {
            return;
        }

        // Find first unattacked square
        bool all_attacked = true;
        size_t ti = 0;
        size_t tj = 0;

        for (size_t i = 0; i < n && all_attacked; i++) {
            for (size_t j = 0; j < n; j++) {
                if (!is_attacked(piece, i, j)) {
                    all_attacked = false;
                    ti = i;
                    tj = j;
                    break;
                }
            }
        }

        if (all_attacked) {
            min_count = count_so_far;
            store_layout(piece);
            return;
        }

        if (count_so_far <= max_count) {
            size_t si, sj;
            if (piece == "K") {
                si = (ti >= 2) ? ti - 2 : 0;
                sj = (tj >= 2) ? tj - 2 : 0;
            } else {
                si = ti;
                sj = tj;
            }

            for (size_t i = si; i < n; i++) {
                for (size_t j = sj; j < n; j++) {
                    if (!is_attacked(piece, i, j)) {
                        if ((i == ti && j == tj) || attacks(piece, i, j, ti, tj)) {
                            // Place piece
                            board[i][j] = true;
                            if (piece != "K") {
                                diag1_lookup[diag1[i][j]] = true;
                                diag2_lookup[diag2[i][j]] = true;
                            }

                            // Recurse
                            place_piece(piece, count_so_far + 1, max_count);

                            // Remove piece (backtrack)
                            board[i][j] = false;
                            if (piece != "K") {
                                diag1_lookup[diag1[i][j]] = false;
                                diag2_lookup[diag2[i][j]] = false;
                            }
                        }
                    }
                }
            }
        }
    }

    size_t get_min_count() const {
        return min_count;
    }

    const std::string& get_layout() const {
        return layout;
    }
};

int main() {
    auto start = std::chrono::high_resolution_clock::now();

    std::vector<std::string> pieces = {"Q", "B", "K"};
    std::unordered_map<std::string, int> limits;
    limits["Q"] = 10;
    limits["B"] = 10;
    limits["K"] = 10;

    std::unordered_map<std::string, std::string> names;
    names["Q"] = "Queens";
    names["B"] = "Bishops";
    names["K"] = "Knights";

    for (const std::string& piece : pieces) {
        std::cout << names[piece] << std::endl;
        std::cout << "=======" << std::endl << std::endl;

        int n = 1;
        while (true) {
            ChessBoard chess_board(n, piece);

            for (size_t max_count = 1; max_count <= static_cast<size_t>(n * n); max_count++) {
                chess_board.place_piece(piece, 0, max_count);
                if (chess_board.get_min_count() <= static_cast<size_t>(n * n)) {
                    break;
                }
            }

            std::cout << std::setw(2) << n << " x " << std::setw(2) << n
                      << " : " << chess_board.get_min_count() << std::endl;

            if (n == limits[piece]) {
                std::cout << std::endl << names[piece] << " on a " << n << " x " << n
                          << " board:" << std::endl << std::endl;
                std::cout << chess_board.get_layout() << std::endl;
                break;
            }

            n++;
        }
    }

    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);
    std::cout << "Took " << duration.count() << "ms" << std::endl;

    return 0;
}
