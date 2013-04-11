module metered;

import tools.threads, tools.log, tools.time, tools.threadpool;

void main() {
  log_threads = false;
  auto done = new Semaphore, lock = new Semaphore(4);
  auto tp = new Threadpool(10);
  for (int i = 0; i < 10; ++i) {
    tp.addTask(i /apply/ (int i) {
      scope(exit) done.release;
      lock.acquire;
      logln(i, ": lock acquired");
      sleep(2.0);
      lock.release;
      logln(i, ": lock released");
    });
  }
  for (int i = 0; i < 10; ++i)
    done.acquire;
}
