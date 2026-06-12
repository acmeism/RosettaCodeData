#include <iostream>
#include <memory>
#include <string>
#include <vector>

class MovieWatcher  // A base class for movie watchers
{
protected:
    std::string m_name;

public:
    explicit MovieWatcher(std::string_view name) : m_name{name}{}

    virtual void WatchMovie()
    {
        std::cout << m_name << " is watching the movie\n";
    }

    virtual void EatPopcorn()
    {
        std::cout << m_name << " is enjoying the popcorn\n";
    }
    virtual ~MovieWatcher() = default;
};

// ParentMovieWatcher cannot be inherited from because it is 'final'
class ParentMovieWatcher final : public MovieWatcher
{
public:
    explicit ParentMovieWatcher(std::string_view name) : MovieWatcher{name} {}
};

// ChildMovieWatcher can be inherited from
class ChildMovieWatcher : public MovieWatcher
{
public:
    explicit ChildMovieWatcher(std::string_view name)
    : MovieWatcher{name}{}

    // EatPopcorn() cannot be overridden because it is 'final'
    void EatPopcorn() final override
    {
        std::cout << m_name << " is eating too much popcorn\n";
    }
};

class YoungChildMovieWatcher : public ChildMovieWatcher
{
public:
    explicit YoungChildMovieWatcher(std::string_view name)
    : ChildMovieWatcher{name}{}

    // WatchMovie() cannot be overridden because it is 'final'
    void WatchMovie() final override
    {
        std::cout << "Sorry, " << m_name <<
            ", you are too young to watch the movie.\n";
    }
};

int main()
{
    // A container for the MovieWatcher base class objects
    std::vector<std::unique_ptr<MovieWatcher>> movieWatchers;

    // Add some movie wathcers
    movieWatchers.emplace_back(new ParentMovieWatcher("Donald"));
    movieWatchers.emplace_back(new ChildMovieWatcher("Lisa"));
    movieWatchers.emplace_back(new YoungChildMovieWatcher("Fred"));

    // Send them to the movies
    std::for_each(movieWatchers.begin(), movieWatchers.end(), [](auto& watcher)
    {
        watcher->WatchMovie();
    });
    std::for_each(movieWatchers.begin(), movieWatchers.end(), [](auto& watcher)
    {
        watcher->EatPopcorn();
    });
}
