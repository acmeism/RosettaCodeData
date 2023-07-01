#include <iomanip>
#include <iostream>
#include <list>
#include <string>
#include <vector>
#include <utility>
#include <vector>

class nest_tree;

bool operator==(const nest_tree&, const nest_tree&);

class nest_tree {
public:
    explicit nest_tree(const std::string& name) : name_(name) {}
    nest_tree& add_child(const std::string& name) {
        children_.emplace_back(name);
        return children_.back();
    }
    void print(std::ostream& out) const {
        print(out, 0);
    }
    const std::string& name() const {
        return name_;
    }
    const std::list<nest_tree>& children() const {
        return children_;
    }
    bool equals(const nest_tree& n) const {
        return name_ == n.name_ && children_ == n.children_;
    }
private:
    void print(std::ostream& out, int level) const {
        std::string indent(level * 4, ' ');
        out << indent << name_ << '\n';
        for (const nest_tree& child : children_)
            child.print(out, level + 1);
    }
    std::string name_;
    std::list<nest_tree> children_;
};

bool operator==(const nest_tree& a, const nest_tree& b) {
    return a.equals(b);
}

class indent_tree {
public:
    explicit indent_tree(const nest_tree& n) {
        items_.emplace_back(0, n.name());
        from_nest(n, 0);
    }
    void print(std::ostream& out) const {
        for (const auto& item : items_)
            std::cout << item.first << ' ' << item.second << '\n';
    }
    nest_tree to_nest() const {
        nest_tree n(items_[0].second);
        to_nest_(n, 1, 0);
        return n;
    }
private:
    void from_nest(const nest_tree& n, int level) {
        for (const nest_tree& child : n.children()) {
            items_.emplace_back(level + 1, child.name());
            from_nest(child, level + 1);
        }
    }
    size_t to_nest_(nest_tree& n, size_t pos, int level) const {
        while (pos < items_.size() && items_[pos].first == level + 1) {
            nest_tree& child = n.add_child(items_[pos].second);
            pos = to_nest_(child, pos + 1, level + 1);
        }
        return pos;
    }
    std::vector<std::pair<int, std::string>> items_;
};

int main() {
    nest_tree n("RosettaCode");
    auto& child1 = n.add_child("rocks");
    auto& child2 = n.add_child("mocks");
    child1.add_child("code");
    child1.add_child("comparison");
    child1.add_child("wiki");
    child2.add_child("trolling");

    std::cout << "Initial nest format:\n";
    n.print(std::cout);

    indent_tree i(n);
    std::cout << "\nIndent format:\n";
    i.print(std::cout);

    nest_tree n2(i.to_nest());
    std::cout << "\nFinal nest format:\n";
    n2.print(std::cout);

    std::cout << "\nAre initial and final nest formats equal? "
        << std::boolalpha << n.equals(n2) << '\n';

    return 0;
}
