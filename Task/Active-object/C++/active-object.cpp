#include <atomic>
#include <chrono>
#include <cmath>
#include <iostream>
#include <mutex>
#include <thread>

using namespace std::chrono_literals;

class Integrator
{
  public:
    using clock_type = std::chrono::high_resolution_clock;
    using dur_t      = std::chrono::duration<double>;
    using func_t     = double(*)(double);

    explicit Integrator(func_t f = nullptr);
    ~Integrator();
    void input(func_t new_input);
    double output() { return integrate(); }

  private:
    std::atomic_flag continue_;
    std::mutex       mutex;
    std::thread      worker;

    func_t                       func;
    double                       state = 0;
    //Improves precision by reducing sin result error on large values
    clock_type::time_point const beginning = clock_type::now();
    clock_type::time_point       t_prev = beginning;

    void do_work();
    double integrate();
};

Integrator::Integrator(func_t f) : func(f)
{
    continue_.test_and_set();
    worker = std::thread(&Integrator::do_work, this);
}

Integrator::~Integrator()
{
    continue_.clear();
    worker.join();
}

void Integrator::input(func_t new_input)
{
    integrate();
    std::lock_guard<std::mutex> lock(mutex);
    func = new_input;
}

void Integrator::do_work()
{
    while (continue_.test_and_set()) {
        integrate();
        std::this_thread::sleep_for(1ms);
    }
}

double Integrator::integrate()
{
    std::lock_guard<std::mutex> lock(mutex);
    auto now = clock_type::now();
    dur_t start = t_prev - beginning;
    dur_t fin   =    now - beginning;
    if (func)
        state += (func(start.count()) + func(fin.count())) * (fin - start).count() / 2;
    t_prev = now;
    return state;
}

double sine(double time)
{
    constexpr double PI = 3.1415926535897932;
    return std::sin(2 * PI * 0.5 * time);
}

int main()
{
    Integrator foo(sine);
    std::this_thread::sleep_for(2s);
    foo.input(nullptr);
    std::this_thread::sleep_for(500ms);
    std::cout << foo.output();
}
