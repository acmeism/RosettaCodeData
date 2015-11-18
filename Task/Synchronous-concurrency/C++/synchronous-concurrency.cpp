#include <future>
#include <iostream>
#include <fstream>
#include <mutex>
#include <queue>
#include <string>
#include <thread>

struct lock_queue
{
    std::queue<std::string> q;
    std::mutex mutex;
};

void reader(std::string filename, std::future<size_t> lines, lock_queue& out)
{
    std::string line;
    std::ifstream in(filename);
    while(std::getline(in, line)) {
        line += '\n';
        std::lock_guard<std::mutex> lock(out.mutex);
        out.q.push(line);
    } {
        std::lock_guard<std::mutex> lock(out.mutex);
        out.q.push("");
    }
    lines.wait();
    std::cout << "\nPrinted " << lines.get() << " lines\n";
}

void printer(std::promise<size_t> lines, lock_queue& in)
{
    std::string s;
    size_t line_n = 0;
    bool print = false;
    while(true) {
        {
            std::lock_guard<std::mutex> lock(in.mutex);
            if(( print = not in.q.empty() )) { //Assignment intended
                s = in.q.front();
                in.q.pop();
            }
        }
        if(print) {
            if(s == "") break;
            std::cout << s;
            ++line_n;
            print = false;
        }
    }
    lines.set_value(line_n);
}

int main()
{
    lock_queue queue;
    std::promise<size_t> promise;
    std::thread t1(reader, "input.txt", promise.get_future(), std::ref(queue));
    std::thread t2(printer, std::move(promise), std::ref(queue));
    t1.join(); t2.join();
}
