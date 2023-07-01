#include <unordered_map>
#include <unordered_set>
#include <vector>

template <typename ValueType>
class topological_sorter
{
public:
    using value_type = ValueType;

protected:
    struct relations
    {
        std::size_t dependencies { 0 };
        std::unordered_set<value_type> dependents {};
    };

    std::unordered_map<value_type, relations> _map {};

public:
    void add(const value_type &object)
    {
        _map.try_emplace(object, relations {});
    }

    void add(const value_type &object, const value_type &dependency)
    {
        if (dependency == object) return;

        auto &dependents = _map[dependency].dependents;

        if (dependents.find(object) == std::end(dependents))
        {
            dependents.insert(object);

            ++_map[object].dependencies;
        }
    }

    template <typename Container>
    void add(const value_type &object, const Container &dependencies)
    {
        for (auto const &dependency : dependencies) add(object, dependency);
    }

    void add(const value_type &object, const std::initializer_list<value_type> &dependencies)
    {
        add<std::initializer_list<value_type>>(object, dependencies);
    }

    template<typename... Args>
    void add(const value_type &object, const Args&... dependencies)
    {
        (add(object, dependencies), ...);
    }

    auto sort()
    {
        std::vector<value_type> sorted, cycled;
        auto map { _map };

        for (const auto &[object, relations] : map) if (!relations.dependencies) sorted.emplace_back(object);

        for (decltype(std::size(sorted)) idx = 0; idx < std::size(sorted); ++idx)
            for (auto const& object : map[sorted[idx]].dependents)
                if (!--map[object].dependencies) sorted.emplace_back(object);

        for (const auto &[object, relations] : map) if (relations.dependencies) cycled.emplace_back(std::move(object));

        return std::pair(std::move(sorted), std::move(cycled));
    }

    void clear()
    {
        _map.clear();
    }
};

/*
	Example usage with shared_ptr to class
*/
#include <iostream>
#include <memory>

int main()
{
    using namespace std::string_literals;

    struct task
    {
        std::string message;

        task(const std::string &v) : message { v } {}
        ~task() { std::cout << message[0] << " - destroyed" << std::endl; }
    };

    using task_ptr = std::shared_ptr<task>;

    std::vector<task_ptr> tasks
    {
        // defining simple tasks
        std::make_shared<task>("A - depends on B and C"s),    //0
        std::make_shared<task>("B - depends on none"s),       //1
        std::make_shared<task>("C - depends on D and E"s),    //2
        std::make_shared<task>("D - depends on none"s),       //3
        std::make_shared<task>("E - depends on F, G and H"s), //4
        std::make_shared<task>("F - depends on I"s),          //5
        std::make_shared<task>("G - depends on none"s),       //6
        std::make_shared<task>("H - depends on none"s),       //7
        std::make_shared<task>("I - depends on none"s),       //8
    };

    topological_sorter<task_ptr> resolver;

    // now setting relations between them as described above
    resolver.add(tasks[0], { tasks[1], tasks[2] });
    //resolver.add(tasks[1]); // no need for this since the task was already mentioned as a dependency
    resolver.add(tasks[2], { tasks[3], tasks[4] });
    //resolver.add(tasks[3]); // no need for this since the task was already mentioned as a dependency
    resolver.add(tasks[4], tasks[5], tasks[6], tasks[7]); // using templated add with fold expression
    resolver.add(tasks[5], tasks[8]);
    //resolver.add(tasks[6]); // no need for this since the task was already mentioned as a dependency
    //resolver.add(tasks[7]); // no need for this since the task was already mentioned as a dependency

    //resolver.add(tasks[3], tasks[0]); // uncomment this line to test cycled dependency

    const auto &[sorted, cycled] = resolver.sort();

    if (std::empty(cycled))
    {
        for (auto const& d: sorted)
            std::cout << d->message << std::endl;
    }
    else
    {
        std::cout << "Cycled dependencies detected: ";

        for (auto const& d: cycled)
            std::cout << d->message[0] << " ";

        std::cout << std::endl;
    }

    //tasks.clear(); // uncomment this line to destroy all tasks in sorted order.

    std::cout << "exiting..." << std::endl;

    return 0;
}
