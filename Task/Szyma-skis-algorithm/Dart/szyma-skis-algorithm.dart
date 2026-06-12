import 'dart:isolate';
import 'dart:async';

class Program {
  static final Map<int, int> dict = <int, int>{};
  static int criticalValue = 1;
  static final Object lockObject = Object();

  static int flag(int id) {
    return dict.putIfAbsent(id, () => 0);
  }

  static Future<void> runSzymanski(int id, List<int> allszy) async {
    List<int> others = allszy.where((t) => t != id).toList();

    dict[id] = 1; // Standing outside waiting room

    while (others.any((t) => flag(t) >= 3)) {
      await Future.delayed(Duration.zero); // Yield
    }

    dict[id] = 3; // Standing in doorway

    if (others.any((t) => flag(t) == 1)) {
      dict[id] = 2; // Waiting for other processes to enter
      while (!others.any((t) => flag(t) == 4)) {
        await Future.delayed(Duration.zero); // Yield
      }
    }

    dict[id] = 4; // The door is closed

    for (int t in others) {
      if (t >= id) continue;
      while (flag(t) > 1) {
        await Future.delayed(Duration.zero); // Yield
      }
    }

    // Critical section
    synchronized(lockObject, () {
      criticalValue += id * 3;
      criticalValue ~/= 2;
      print("Thread $id changed the critical value to $criticalValue.");
    });
    // End critical section

    // Exit protocol
    for (int t in others) {
      if (t <= id) continue;
      while (![0, 1, 4].contains(flag(t))) {
        await Future.delayed(Duration.zero); // Yield
      }
    }

    dict[id] = 0; // Leave. Reopen door if nobody is still in the waiting room
  }

  static Future<void> testSzymanski(int n) async {
    List<int> allszy = List.generate(n, (index) => index + 1);
    List<Future<void>> futures = [];

    for (int i in allszy) {
      futures.add(runSzymanski(i, allszy));
    }

    await Future.wait(futures);
  }
}

// Helper function to simulate synchronized block
void synchronized(Object lock, Function() block) {
  // In Dart, there's no built-in synchronized block.
  // You can use a mutex-like pattern if needed.
  block();
}

// Top-level main function - This is the entry point for the Dart program
void main() async {
  await Program.testSzymanski(20);
}
