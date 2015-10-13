#include <algorithm>
#include <array>
#include <atomic>
#include <chrono>
//We are using only standard library, so snprintf instead of Boost::Format
#include <cstdio>
#include <iostream>
#include <mutex>
#include <random>
#include <string>
#include <thread>

std::mutex cout_mutex;

struct Fork {
    std::mutex mutex;
};

struct Dinner {
    std::atomic<bool> ready {false};
    std::array<Fork, 5> forks;
    ~Dinner() { std::cout << "Dinner is over"; }
};

class Philosopher
{
    std::mt19937 rng{std::random_device {}()};

    const std::string name;
    const Dinner& dinner;
    Fork& left;
    Fork& right;
    std::thread worker;

    void live();
    void dine();
    void ponder();
  public:
    Philosopher(std::string name_, const Dinner& dinn, Fork& l, Fork& r)
      : name(std::move(name_)), dinner(dinn) , left(l), right(r), worker(&Philosopher::live, this)
    {}
    ~Philosopher()
    {
        worker.join();
        std::lock_guard<std::mutex>  cout_lock(cout_mutex);
        std::cout << name << " went to sleep." << std::endl;
    }
};

void Philosopher::live()
{
    while (not dinner.ready)
        ; //You spin me right round, baby, right round...
    do {//Aquire forks first
        //lock uses deadlock prevention mechanism to acquire mutexes safely
        std::lock(left.mutex, right.mutex);
        dine(); //Dine adopts lock on forks and releases them
        if(not dinner.ready) break;
        ponder();
    } while(dinner.ready);
}

void Philosopher::dine()
{
    std::lock_guard<std::mutex>  left_lock( left.mutex, std::adopt_lock);
    std::lock_guard<std::mutex> right_lock(right.mutex, std::adopt_lock);

    thread_local std::array<const char*, 3> foods {{"chicken", "rice", "soda"}};
    thread_local std::array<const char*, 3> reactions {{
        "I like this %s!", "This %s is good.", "Mmm, %s..."
    }};
    thread_local std::uniform_int_distribution<> dist(1, 6);
    std::shuffle(    foods.begin(),     foods.end(), rng);
    std::shuffle(reactions.begin(), reactions.end(), rng);

    if(not dinner.ready) return;
    {
        std::lock_guard<std::mutex>  cout_lock(cout_mutex);
        std::cout << name << " started eating." << std::endl;
    }
    constexpr size_t buf_size = 64;
    char buffer[buf_size];
    for(int i = 0; i < 3; ++i) {
        std::this_thread::sleep_for(std::chrono::milliseconds(dist(rng)*50));
        snprintf(buffer, buf_size, reactions[i], foods[i]);
        std::lock_guard<std::mutex>  cout_lock(cout_mutex);
        std::cout << name << ": " << buffer << std::endl;
    }
    std::this_thread::sleep_for(std::chrono::milliseconds(dist(rng))*50);
    std::lock_guard<std::mutex>  cout_lock(cout_mutex);
    std::cout << name << " finished and left." << std::endl;
}

void Philosopher::ponder()
{
    static constexpr std::array<const char*, 5> topics {{
        "politics", "art", "meaning of life", "source of morality", "how many straws makes a bale"
    }};
    thread_local std::uniform_int_distribution<> wait(1, 6);
    thread_local std::uniform_int_distribution<> dist(0, topics.size() - 1);
    while(dist(rng) > 0) {
        std::this_thread::sleep_for(std::chrono::milliseconds(wait(rng)*150));
        std::lock_guard<std::mutex>  cout_lock(cout_mutex);
        std::cout << name << " is pondering about " << topics[dist(rng)] << '.' << std::endl;
        if(not dinner.ready) return;
    }
    std::this_thread::sleep_for(std::chrono::milliseconds(wait(rng)*150));
    std::lock_guard<std::mutex>  cout_lock(cout_mutex);
    std::cout << name << " is hungry again!" << std::endl;
}

int main()
{
    Dinner dinner;
    std::array<Philosopher, 5> philosophers {{
            {"Aristotle", dinner, dinner.forks[0], dinner.forks[1]},
            {"Kant",      dinner, dinner.forks[1], dinner.forks[2]},
            {"Spinoza",   dinner, dinner.forks[2], dinner.forks[3]},
            {"Marx",      dinner, dinner.forks[3], dinner.forks[4]},
            {"Russell",   dinner, dinner.forks[4], dinner.forks[0]},
    }};
    std::this_thread::sleep_for(std::chrono::seconds(1));
    std::cout << "Dinner started!" << std::endl;
    dinner.ready = true;
    std::this_thread::sleep_for(std::chrono::seconds(5));
    dinner.ready = false;
    std::lock_guard<std::mutex>  cout_lock(cout_mutex);
    std::cout << "It is dark outside..." << std::endl;
}
