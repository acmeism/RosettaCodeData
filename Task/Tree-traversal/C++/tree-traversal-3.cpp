#include <iostream>
#include <memory>
#include <queue>

template <typename T>
class node {
public:
    node(T value) : value_(value) {}
    node(T value, std::unique_ptr<node>&& left)
        : value_(value), left_(std::move(left)) {}
    node(T value, std::unique_ptr<node>&& left, std::unique_ptr<node>&& right)
        : value_(value), left_(std::move(left)), right_(std::move(right)) {}

    template <typename Function>
    void pre_order(Function f) {
        f(value_);
        if (left_)
            left_->pre_order(f);
        if (right_)
            right_->pre_order(f);
    }

    template <typename Function>
    void in_order(Function f) {
        if (left_)
            left_->in_order(f);
        f(value_);
        if (right_)
            right_->in_order(f);
    }

    template <typename Function>
    void post_order(Function f) {
        if (left_)
            left_->post_order(f);
        if (right_)
            right_->post_order(f);
        f(value_);
    }

    template <typename Function>
    void level_order(Function f) {
        std::queue<node*> queue;
        queue.push(this);
        while (!queue.empty()) {
            node* next = queue.front();
            queue.pop();
            f(next->value_);
            if (next->left_)
                queue.push(next->left_.get());
            if (next->right_)
                queue.push(next->right_.get());
        }
    }
private:
    T value_;
    std::unique_ptr<node> left_;
    std::unique_ptr<node> right_;
};

template <typename T, typename... Args>
std::unique_ptr<node<T>>
tree(T value, Args&&... args) {
    return std::make_unique<node<T>>(value, std::forward<Args>(args)...);
}

int main() {
    node<int> n(1,
                tree(2,
                     tree(4,
                          tree(7)),
                     tree(5)),
                tree(3,
                     tree(6,
                          tree(8),
                          tree(9))));

    auto print = [](int n) { std::cout << n << ' '; };

    std::cout << "pre-order:   ";
    n.pre_order(print);
    std::cout << '\n';

    std::cout << "in-order:    ";
    n.in_order(print);
    std::cout << '\n';

    std::cout << "post-order:  ";
    n.post_order(print);
    std::cout << '\n';

    std::cout << "level-order: ";
    n.level_order(print);
    std::cout << '\n';
}
