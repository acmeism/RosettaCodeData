#include <iostream>
#include <vector>
#include <numeric>

// ----------------------------------------------------------------------------

using Row   = std::vector<int>;
using Cells = std::vector<Row>;

// ----------------------------------------------------------------------------

Cells board = {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
};

int numRows = 10;
int numCols = 20;

// ----------------------------------------------------------------------------

int getNeighbor(int row, int col, Cells& board) {
    // use modulus to get wrapping effect at board edges
    return board.at((row + numRows) % numRows).at((col + numCols) % numCols);
}

int getCount(int row, int col, Cells& board) {
    int count = 0;
    std::vector<int> deltas {-1, 0, 1};
    for (int dc : deltas) {
        for (int dr : deltas) {
            if (dr || dc) {
                count += getNeighbor(row + dr, col + dc, board);
            }
        }
    }
    return count;
}

void showCell(int cell) {
    std::cout << (cell ? "*" : " ");
}

void showRow(const Row& row) {
    std::cout << "|";
    for (int cell : row) {showCell(cell);}
    std::cout << "|\n";
}

void showCells(Cells board) {
    for (const Row& row : board) { showRow(row); }
}

int tick(Cells& board, int row, int col) {
    int count = getCount(row, col, board);
    bool birth = !board.at(row).at(col) && count == 3;
    bool survive = board.at(row).at(col) && (count == 2 || count == 3);
    return birth || survive;
}

void updateCells(Cells& board) {
    Cells original = board;
    for (int row = 0; row < numRows; row++) {
        for (int col = 0; col < numCols; col++) {
            board.at(row).at(col) = tick(original, row, col);
        }
    }
}

int main () {
    for (int gen = 0; gen < 20; gen++) {
        std::cout << "\ngeneration " << gen << ":\n";
        showCells(board);
        updateCells(board);
    }
}
