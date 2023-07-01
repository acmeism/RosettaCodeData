//
// C++ implementation of Tarjan's strongly connected components algorithm
// See https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm
//
#include <algorithm>
#include <iostream>
#include <list>
#include <string>
#include <vector>

struct noncopyable {
    noncopyable() {}
    noncopyable(const noncopyable&) = delete;
    noncopyable& operator=(const noncopyable&) = delete;
};

template <typename T>
class tarjan;

template <typename T>
class vertex : private noncopyable {
public:
    explicit vertex(const T& t) : data_(t) {}
    void add_neighbour(vertex* v) {
        neighbours_.push_back(v);
    }
    void add_neighbours(const std::initializer_list<vertex*>& vs) {
        neighbours_.insert(neighbours_.end(), vs);
    }
    const T& get_data() {
        return data_;
    }
private:
    friend tarjan<T>;
    T data_;
    int index_ = -1;
    int lowlink_ = -1;
    bool on_stack_ = false;
    std::vector<vertex*> neighbours_;
};

template <typename T>
class graph : private noncopyable {
public:
    vertex<T>* add_vertex(const T& t) {
        vertexes_.emplace_back(t);
        return &vertexes_.back();
    }
private:
    friend tarjan<T>;
    std::list<vertex<T>> vertexes_;
};

template <typename T>
class tarjan  : private noncopyable {
public:
    using component = std::vector<vertex<T>*>;
    std::list<component> run(graph<T>& graph) {
        index_ = 0;
        stack_.clear();
        strongly_connected_.clear();
        for (auto& v : graph.vertexes_) {
            if (v.index_ == -1)
                strongconnect(&v);
        }
        return strongly_connected_;
    }
private:
    void strongconnect(vertex<T>* v) {
        v->index_ = index_;
        v->lowlink_ = index_;
        ++index_;
        stack_.push_back(v);
        v->on_stack_ = true;
        for (auto w : v->neighbours_) {
            if (w->index_ == -1) {
                strongconnect(w);
                v->lowlink_ = std::min(v->lowlink_, w->lowlink_);
            }
            else if (w->on_stack_) {
                v->lowlink_ = std::min(v->lowlink_, w->index_);
            }
        }
        if (v->lowlink_ == v->index_) {
            strongly_connected_.push_back(component());
            component& c = strongly_connected_.back();
            for (;;) {
                auto w = stack_.back();
                stack_.pop_back();
                w->on_stack_ = false;
                c.push_back(w);
                if (w == v)
                    break;
            }
        }
    }
    int index_ = 0;
    std::list<vertex<T>*> stack_;
    std::list<component> strongly_connected_;
};

template <typename T>
void print_vector(const std::vector<vertex<T>*>& vec) {
    if (!vec.empty()) {
        auto i = vec.begin();
        std::cout << (*i)->get_data();
        for (++i; i != vec.end(); ++i)
            std::cout << ' ' << (*i)->get_data();
    }
    std::cout << '\n';
}

int main() {
    graph<std::string> g;
    auto andy = g.add_vertex("Andy");
    auto bart = g.add_vertex("Bart");
    auto carl = g.add_vertex("Carl");
    auto dave = g.add_vertex("Dave");
    auto earl = g.add_vertex("Earl");
    auto fred = g.add_vertex("Fred");
    auto gary = g.add_vertex("Gary");
    auto hank = g.add_vertex("Hank");

    andy->add_neighbour(bart);
    bart->add_neighbour(carl);
    carl->add_neighbour(andy);
    dave->add_neighbours({bart, carl, earl});
    earl->add_neighbours({dave, fred});
    fred->add_neighbours({carl, gary});
    gary->add_neighbour(fred);
    hank->add_neighbours({earl, gary, hank});

    tarjan<std::string> t;
    for (auto&& s : t.run(g))
        print_vector(s);
    return 0;
}
