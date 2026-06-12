#include <iostream>
#include <vector>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <unordered_map>
#include <algorithm>
#include <random>
#include <chrono>

// Define constants for state representation
const int OUTSIDE = 0;
const int WAITING_ROOM = 1;
const int DOORWAY = 3;
const int WAITING_FOR_OTHERS = 2;
const int IN_CRITICAL_SECTION = 4;

void run_szymanski(int id, const std::vector<int>& all_szy, std::pair<std::mutex, std::condition_variable>& dict, std::mutex& critical_value_mutex, int& critical_value);
void test_szymanski(int n);

int main() {
    test_szymanski(20);
    return 0;
}

void run_szymanski(int id, const std::vector<int>& all_szy, std::pair<std::mutex, std::condition_variable>& dict, std::mutex& critical_value_mutex, int& critical_value) {
    std::vector<int> others;
    for (int t : all_szy) {
        if (t != id) {
            others.push_back(t);
        }
    }

    // Standing outside waiting room
    {
        std::lock_guard<std::mutex> lock(dict.first);
        std::unordered_map<int, int> flags;
        flags[id] = WAITING_ROOM;

        // Copy the flags to the shared data structure.
        //This prevents race conditions.
        //We must get and set flags using a single lock
        //This is one reason to use C++ 20 and above, as this is one of the functions
        //Where a lock free implementation is possible.
         //dict.second.notify_all(); //Unnecessary notify. Remove it.
    }

    // Wait until no other process is in or passing through the doorway.
    while (std::any_of(others.begin(), others.end(), [&](int t) {
        std::lock_guard<std::mutex> lock(dict.first);
        std::unordered_map<int, int> flags;
        return flags.count(t) > 0 && flags[t] >= DOORWAY;
    })) {
        std::this_thread::yield();
    }

    // Standing in doorway
    {
        std::lock_guard<std::mutex> lock(dict.first);
        std::unordered_map<int, int> flags;
        flags[id] = DOORWAY;
        // Copy the flags to the shared data structure.
        //This prevents race conditions.
         //dict.second.notify_all(); //Unnecessary notify. Remove it.
    }

    // Check if other processes are still waiting
    if (std::any_of(others.begin(), others.end(), [&](int t) {
        std::lock_guard<std::mutex> lock(dict.first);
        std::unordered_map<int, int> flags;
        return flags.count(t) > 0 && flags[t] == WAITING_ROOM;
    })) {
        // Waiting for other processes to enter
        {
            std::lock_guard<std::mutex> lock(dict.first);
            std::unordered_map<int, int> flags;
            flags[id] = WAITING_FOR_OTHERS;
            // Copy the flags to the shared data structure.
             dict.second.notify_all();
        }


        // Wait for other processes to close the door
        while (!std::any_of(others.begin(), others.end(), [&](int t) {
             std::unique_lock<std::mutex> lock(dict.first);

             std::unordered_map<int, int> flags;
             dict.second.wait(lock, [&flags, t]{
                return flags.count(t) > 0 && flags[t] == IN_CRITICAL_SECTION;
             });


            return flags.count(t) > 0 && flags[t] == IN_CRITICAL_SECTION;
        })) {
            std::this_thread::yield();
        }
    }

    // The door is closed
    {
        std::lock_guard<std::mutex> lock(dict.first);
        std::unordered_map<int, int> flags;
        flags[id] = IN_CRITICAL_SECTION;
         dict.second.notify_all();
    }

    // Wait for lower numbered processes
    for (int t : others) {
        if (t >= id) {
            continue;
        }
        while (true) {

             std::unique_lock<std::mutex> lock(dict.first);
            std::unordered_map<int, int> flags;

             bool condition = flags.count(t) > 0 && flags[t] > WAITING_ROOM;
            if(!condition){
              break;
            }
            std::this_thread::yield();
        }
    }

    // Critical section
    {
        std::lock_guard<std::mutex> lock(critical_value_mutex);
        critical_value += id * 3;
        critical_value /= 2;
        std::cout << "Thread " << id << " changed the critical value to " << critical_value << "." << std::endl;
    }

    // Exit protocol
    for (int t : others) {
        if (t <= id) {
            continue;
        }

        while (true) {
            std::unique_lock<std::mutex> lock(dict.first);

            std::unordered_map<int, int> flags;

             bool condition = flags.count(t) == 0 || (flags[t] != OUTSIDE && flags[t] != WAITING_ROOM && flags[t] != IN_CRITICAL_SECTION);

            if(!condition){
              break;
            }

            std::this_thread::yield();
        }
    }

    // Leave
    {
        std::lock_guard<std::mutex> lock(dict.first);
        std::unordered_map<int, int> flags;
        flags[id] = OUTSIDE;
         dict.second.notify_all();
    }
}


void test_szymanski(int n) {
    std::vector<int> all_szy;
    for (int i = 1; i <= n; ++i) {
        all_szy.push_back(i);
    }

    std::pair<std::mutex, std::condition_variable> dict;
    int critical_value = 1;
    std::mutex critical_value_mutex;

    std::vector<std::thread> threads;
    for (int i : all_szy) {
        threads.emplace_back([&, i]() {
            run_szymanski(i, all_szy, dict, critical_value_mutex, critical_value);
        });
    }

    for (auto& t : threads) {
        t.join();
    }
}
