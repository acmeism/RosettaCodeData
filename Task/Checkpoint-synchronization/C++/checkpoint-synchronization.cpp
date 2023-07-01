#include <iostream>
#include <chrono>
#include <atomic>
#include <mutex>
#include <random>
#include <thread>

std::mutex cout_lock;

class Latch
{
    std::atomic<int> semafor;
  public:
    Latch(int limit) : semafor(limit) {}

    void wait()
    {
        semafor.fetch_sub(1);
        while(semafor.load() > 0)
            std::this_thread::yield();
    }
};

struct Worker
{
    static void do_work(int how_long, Latch& barrier, std::string name)
    {
        std::this_thread::sleep_for(std::chrono::milliseconds(how_long));
        {   std::lock_guard<std::mutex> lock(cout_lock);
            std::cout << "Worker " << name << " finished work\n";   }
        barrier.wait();
        {   std::lock_guard<std::mutex> lock(cout_lock);
            std::cout << "Worker " << name << " finished assembly\n";   }
    }
};

int main()
{
    Latch latch(5);
    std::mt19937 rng(std::random_device{}());
    std::uniform_int_distribution<> dist(300, 3000);
    std::thread threads[] {
        std::thread(&Worker::do_work, dist(rng), std::ref(latch), "John"),
        std::thread{&Worker::do_work, dist(rng), std::ref(latch), "Henry"},
        std::thread{&Worker::do_work, dist(rng), std::ref(latch), "Smith"},
        std::thread{&Worker::do_work, dist(rng), std::ref(latch), "Jane"},
        std::thread{&Worker::do_work, dist(rng), std::ref(latch), "Mary"},
    };
    for(auto& t: threads) t.join();
    std::cout << "Assembly is finished";
}
