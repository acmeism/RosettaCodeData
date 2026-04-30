import 'dart:io';

class Relations<T> {
  int dependencies = 0;
  Set<T> dependents = <T>{};
}

class TopologicalSorter<T> {
  Map<T, Relations<T>> _map = <T, Relations<T>>{};

  void addGoal(T goal) {
    _map.putIfAbsent(goal, () => Relations<T>());
  }

  void addDependency(T goal, T dependency) {
    if (dependency == goal) return;

    var dependencyRelations = _map.putIfAbsent(dependency, () => Relations<T>());
    var goalRelations = _map.putIfAbsent(goal, () => Relations<T>());

    if (!dependencyRelations.dependents.contains(goal)) {
      dependencyRelations.dependents.add(goal);
      goalRelations.dependencies++;
    }
  }

  void addDependencies(T goal, Iterable<T> dependencies) {
    for (var dependency in dependencies) {
      addDependency(goal, dependency);
    }
  }

  void destructiveSort(List<T> sorted, List<T> unsortable) {
    sorted.clear();
    unsortable.clear();

    // Find all goals with no dependencies
    for (var entry in _map.entries) {
      var goal = entry.key;
      var relations = entry.value;
      if (relations.dependencies == 0) {
        sorted.add(goal);
      }
    }

    // Process goals in topological order
    for (int index = 0; index < sorted.length; index++) {
      var currentGoal = sorted[index];
      var currentRelations = _map[currentGoal]!;

      for (var dependentGoal in currentRelations.dependents) {
        var dependentRelations = _map[dependentGoal]!;
        dependentRelations.dependencies--;
        if (dependentRelations.dependencies == 0) {
          sorted.add(dependentGoal);
        }
      }
    }

    // Find cyclic dependencies
    for (var entry in _map.entries) {
      var goal = entry.key;
      var relations = entry.value;
      if (relations.dependencies != 0) {
        unsortable.add(goal);
      }
    }
  }

  void sort(List<T> sorted, List<T> unsortable) {
    var temporary = TopologicalSorter<T>();

    // Deep copy the current state
    for (var entry in _map.entries) {
      var goal = entry.key;
      var relations = entry.value;
      temporary.addGoal(goal);
      temporary._map[goal]!.dependencies = relations.dependencies;
      temporary._map[goal]!.dependents = Set<T>.from(relations.dependents);
    }

    temporary.destructiveSort(sorted, unsortable);
  }

  void clear() {
    _map.clear();
  }
}

void displayHeading(String message) {
  print('\n~ $message ~');
}

void displayResults(String input) {
  var sorter = TopologicalSorter<String>();
  var sorted = <String>[];
  var unsortable = <String>[];

  var lines = input.trim().split('\n');
  for (var line in lines) {
    if (line.trim().isEmpty) continue;

    var parts = line.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) continue;

    var goal = parts[0];
    sorter.addGoal(goal);

    for (int i = 1; i < parts.length; i++) {
      sorter.addDependency(goal, parts[i]);
    }
  }

  sorter.destructiveSort(sorted, unsortable);

  if (sorted.isEmpty) {
    displayHeading("Error: no independent variables found!");
  } else {
    displayHeading("Result");
    for (var goal in sorted) {
      print(goal);
    }
  }

  if (unsortable.isNotEmpty) {
    displayHeading("Error: cyclic dependencies detected!");
    for (var goal in unsortable) {
      print(goal);
    }
  }
}

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    var example = '''des_system_lib   std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee
dw01             ieee dw01 dware gtech
dw02             ieee dw02 dware
dw03             std synopsys dware dw03 dw02 dw01 ieee gtech
dw04             dw04 ieee dw01 dware gtech
dw05             dw05 ieee dware
dw06             dw06 ieee dware
dw07             ieee dware
dware            ieee dware
gtech            ieee gtech
ramlib           std ieee
std_cell_lib     ieee std_cell_lib
synopsys
cycle_11     cycle_12
cycle_12     cycle_11
cycle_21     dw01 cycle_22 dw02 dw03
cycle_22     cycle_21 dw01 dw04''';

    displayHeading("Example: each line starts with a goal followed by its dependencies");
    print(example);
    displayResults(example);

    displayHeading("Enter lines of data (press enter when finished)");
    var lines = <String>[];
    while (true) {
      var line = stdin.readLineSync();
      if (line == null || line.isEmpty) break;
      lines.add(line);
    }

    if (lines.isNotEmpty) {
      displayResults(lines.join('\n'));
    }
  } else {
    for (var filename in arguments) {
      try {
        var file = File(filename);
        var content = file.readAsStringSync();
        displayResults(content);
      } catch (e) {
        print('Error reading file $filename: $e');
      }
    }
  }
}
