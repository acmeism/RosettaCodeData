import threading
import time
from collections import defaultdict

dict_ = defaultdict(int)  # Use defaultdict for GetOrAdd functionality
critical_value = 1
lock_object = threading.Lock()


def flag(id_):
    return dict_[id_]


def run_szymanski(id_, allszy):
    others = [t for t in allszy if t != id_]
    dict_[id_] = 1  # Standing outside waiting room
    while any(flag(t) >= 3 for t in others):
        time.sleep(0.001)  # Thread.Yield() equivalent
    dict_[id_] = 3  # Standing in doorway
    if any(flag(t) == 1 for t in others):
        dict_[id_] = 2  # Waiting for other processes to enter
        while not any(flag(t) == 4 for t in others):
            time.sleep(0.001)  # Thread.Yield() equivalent
    dict_[id_] = 4  # The door is closed
    for t in others:
        if t >= id_:
            continue
        while flag(t) > 1:
            time.sleep(0.001)  # Thread.Yield() equivalent

    # critical section
    with lock_object:
        global critical_value
        critical_value += id_ * 3
        critical_value //= 2
        print(f"Thread {id_} changed the critical value to {critical_value}.")
    # end critical section

    # Exit protocol
    for t in others:
        if t <= id_:
            continue
        while flag(t) not in [0, 1, 4]:
            time.sleep(0.001)  # Thread.Yield() equivalent
    dict_[id_] = 0  # Leave. Reopen door if nobody is still in the waiting room


def test_szymanski(n):
    allszy = list(range(1, n + 1))
    threads = [threading.Thread(target=run_szymanski, args=(i, allszy)) for i in allszy]

    for thread in threads:
        thread.start()

    for thread in threads:
        thread.join()


if __name__ == "__main__":
    test_szymanski(20)
