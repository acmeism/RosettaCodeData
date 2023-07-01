#include <chrono>
#include <iostream>
#include <format>
#include <semaphore>
#include <thread>

using namespace std::literals;

void Worker(std::counting_semaphore<>& semaphore, int id)
{	
    semaphore.acquire();
    std::cout << std::format("Thread {} has a semaphore & is now working.\n", id); // response message
    std::this_thread::sleep_for(2s);
    std::cout << std::format("Thread {} done.\n", id);
    semaphore.release();
}

int main()
{
    const auto numOfThreads = static_cast<int>( std::thread::hardware_concurrency() );
    std::counting_semaphore<> semaphore{numOfThreads / 2};

    std::vector<std::jthread> tasks;
    for (int id = 0; id < numOfThreads; ++id)
	tasks.emplace_back(Worker, std::ref(semaphore), id);

    return 0;
}
