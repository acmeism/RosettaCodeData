#include <iostream>
#include <functional>
#include <map>
#include <vector>

struct Node {
    int length;
    std::map<char, int> edges;
    int suffix;

    Node(int l) : length(l), suffix(0) {
        /* empty */
    }

    Node(int l, const std::map<char, int>& m, int s) : length(l), edges(m), suffix(s) {
        /* empty */
    }
};

constexpr int evenRoot = 0;
constexpr int oddRoot = 1;

std::vector<Node> eertree(const std::string& s) {
    std::vector<Node> tree = {
        Node(0, {}, oddRoot),
        Node(-1, {}, oddRoot)
    };
    int suffix = oddRoot;
    int n, k;

    for (size_t i = 0; i < s.length(); ++i) {
        char c = s[i];
        for (n = suffix; ; n = tree[n].suffix) {
            k = tree[n].length;
            int b = i - k - 1;
            if (b >= 0 && s[b] == c) {
                break;
            }
        }

        auto it = tree[n].edges.find(c);
        auto end = tree[n].edges.end();
        if (it != end) {
            suffix = it->second;
            continue;
        }
        suffix = tree.size();
        tree.push_back(Node(k + 2));
        tree[n].edges[c] = suffix;
        if (tree[suffix].length == 1) {
            tree[suffix].suffix = 0;
            continue;
        }
        while (true) {
            n = tree[n].suffix;
            int b = i - tree[n].length - 1;
            if (b >= 0 && s[b] == c) {
                break;
            }
        }
        tree[suffix].suffix = tree[n].edges[c];
    }

    return tree;
}

std::vector<std::string> subPalindromes(const std::vector<Node>& tree) {
    std::vector<std::string> s;

    std::function<void(int, std::string)> children;
    children = [&children, &tree, &s](int n, std::string p) {
        auto it = tree[n].edges.cbegin();
        auto end = tree[n].edges.cend();
        for (; it != end; it = std::next(it)) {
            auto c = it->first;
            auto m = it->second;

            std::string pl = c + p + c;
            s.push_back(pl);
            children(m, pl);
        }
    };
    children(0, "");

    auto it = tree[1].edges.cbegin();
    auto end = tree[1].edges.cend();
    for (; it != end; it = std::next(it)) {
        auto c = it->first;
        auto n = it->second;

        std::string ct(1, c);
        s.push_back(ct);

        children(n, ct);
    }

    return s;
}

int main() {
    using namespace std;

    auto tree = eertree("eertree");
    auto pal = subPalindromes(tree);

    auto it = pal.cbegin();
    auto end = pal.cend();

    cout << "[";
    if (it != end) {
        cout << it->c_str();
        it++;
    }
    while (it != end) {
        cout << ", " << it->c_str();
        it++;
    }
    cout << "]" << endl;

    return 0;
}
