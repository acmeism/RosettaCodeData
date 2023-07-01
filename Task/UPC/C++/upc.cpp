#include <iostream>
#include <locale>
#include <map>
#include <vector>

std::string trim(const std::string &str) {
    auto s = str;

    //rtrim
    auto it1 = std::find_if(s.rbegin(), s.rend(), [](char ch) { return !std::isspace<char>(ch, std::locale::classic()); });
    s.erase(it1.base(), s.end());

    //ltrim
    auto it2 = std::find_if(s.begin(), s.end(), [](char ch) { return !std::isspace<char>(ch, std::locale::classic()); });
    s.erase(s.begin(), it2);

    return s;
}

template <typename T>
std::ostream &operator<<(std::ostream &os, const std::vector<T> &v) {
    auto it = v.cbegin();
    auto end = v.cend();

    os << '[';
    if (it != end) {
        os << *it;
        it = std::next(it);
    }
    while (it != end) {
        os << ", " << *it;
        it = std::next(it);
    }
    return os << ']';
}

const std::map<std::string, int> LEFT_DIGITS = {
    {"   ## #", 0},
    {"  ##  #", 1},
    {"  #  ##", 2},
    {" #### #", 3},
    {" #   ##", 4},
    {" ##   #", 5},
    {" # ####", 6},
    {" ### ##", 7},
    {" ## ###", 8},
    {"   # ##", 9}
};

const std::map<std::string, int> RIGHT_DIGITS = {
    {"###  # ", 0},
    {"##  ## ", 1},
    {"## ##  ", 2},
    {"#    # ", 3},
    {"# ###  ", 4},
    {"#  ### ", 5},
    {"# #    ", 6},
    {"#   #  ", 7},
    {"#  #   ", 8},
    {"### #  ", 9}
};

const std::string END_SENTINEL = "# #";
const std::string MID_SENTINEL = " # # ";

void decodeUPC(const std::string &input) {
    auto decode = [](const std::string &candidate) {
        using OT = std::vector<int>;
        OT output;
        size_t pos = 0;

        auto part = candidate.substr(pos, END_SENTINEL.length());
        if (part == END_SENTINEL) {
            pos += END_SENTINEL.length();
        } else {
            return std::make_pair(false, OT{});
        }

        for (size_t i = 0; i < 6; i++) {
            part = candidate.substr(pos, 7);
            pos += 7;

            auto e = LEFT_DIGITS.find(part);
            if (e != LEFT_DIGITS.end()) {
                output.push_back(e->second);
            } else {
                return std::make_pair(false, output);
            }
        }

        part = candidate.substr(pos, MID_SENTINEL.length());
        if (part == MID_SENTINEL) {
            pos += MID_SENTINEL.length();
        } else {
            return std::make_pair(false, OT{});
        }

        for (size_t i = 0; i < 6; i++) {
            part = candidate.substr(pos, 7);
            pos += 7;

            auto e = RIGHT_DIGITS.find(part);
            if (e != RIGHT_DIGITS.end()) {
                output.push_back(e->second);
            } else {
                return std::make_pair(false, output);
            }
        }

        part = candidate.substr(pos, END_SENTINEL.length());
        if (part == END_SENTINEL) {
            pos += END_SENTINEL.length();
        } else {
            return std::make_pair(false, OT{});
        }

        int sum = 0;
        for (size_t i = 0; i < output.size(); i++) {
            if (i % 2 == 0) {
                sum += 3 * output[i];
            } else {
                sum += output[i];
            }
        }
        return std::make_pair(sum % 10 == 0, output);
    };

    auto candidate = trim(input);

    auto out = decode(candidate);
    if (out.first) {
        std::cout << out.second << '\n';
    } else {
        std::reverse(candidate.begin(), candidate.end());
        out = decode(candidate);
        if (out.first) {
            std::cout << out.second << " Upside down\n";
        } else if (out.second.size()) {
            std::cout << "Invalid checksum\n";
        } else {
            std::cout << "Invalid digit(s)\n";
        }
    }
}

int main() {
    std::vector<std::string> barcodes = {
        "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
        "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",
        "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",
        "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
        "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",
        "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",
        "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",
        "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",
        "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
        "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         ",
    };
    for (auto &barcode : barcodes) {
        decodeUPC(barcode);
    }
    return 0;
}
