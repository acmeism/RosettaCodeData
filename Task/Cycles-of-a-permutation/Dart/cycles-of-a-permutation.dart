import 'dart:collection';

void main() {
  final permutation = Permutation(Day.monday.letters.length);

  print("On Thursdays Alf and Betty should rearrange their letters using these cycles:");
  final oneLineWedThu = permutation.createOneLine(Day.wednesday.letters, Day.thursday.letters);
  final cyclesWedThu = permutation.oneLineToCycles(oneLineWedThu);
  print(cyclesWedThu);
  print("So that ${Day.wednesday.letters} becomes ${Day.thursday.letters}");

  print("\nOr they could use the one line notation:");
  print(oneLineWedThu);

  print("\nTo revert to the Wednesday arrangement they should use these cycles:");
  final cyclesThuWed = permutation.cyclesInverse(cyclesWedThu);
  print(cyclesThuWed);

  print("\nOr with the one line notation:");
  final oneLineThuWed = permutation.oneLineInverse(oneLineWedThu);
  print(oneLineThuWed);
  print("So that ${Day.thursday.letters} becomes ${permutation.oneLinePermuteString(Day.thursday.letters, oneLineThuWed)}");

  print("\nStarting with the Sunday arrangement and applying each of the daily");
  print("arrangements consecutively, the arrangements will be:");
  print("\n${" " * 6}${Day.sunday.letters}\n");

  for (final day in Day.values) {
    final dayOneLine = permutation.createOneLine(day.previous().letters, day.letters);
    final result = permutation.oneLinePermuteString(day.previous().letters, dayOneLine);
    print("${day.name}: $result${day == Day.saturday ? "\n" : ""}");
  }

  print("\nTo go from Wednesday to Friday in a single step they should use these cycles:");
  final oneLineThuFri = permutation.createOneLine(Day.thursday.letters, Day.friday.letters);
  final cyclesThuFri = permutation.oneLineToCycles(oneLineThuFri);
  final cyclesWedFri = permutation.combinedCycles(cyclesWedThu, cyclesThuFri);
  print(cyclesWedFri);
  print("So that ${Day.wednesday.letters} becomes ${permutation.cyclesPermuteString(Day.wednesday.letters, cyclesWedFri)}");

  print("\nThese are the signatures of the permutations:\n");
  for (final day in Day.values) {
    final oneLine = permutation.createOneLine(day.previous().letters, day.letters);
    print("${day.name}: ${permutation.signature(oneLine)}");
  }

  print("\nThese are the orders of the permutations:\n");
  for (final day in Day.values) {
    final oneLine = permutation.createOneLine(day.previous().letters, day.letters);
    print("${day.name}: ${permutation.order(oneLine)}");
  }

  print("\nApplying the Friday cycle to a string 10 times:");
  var word = "STOREDAILYPUNCH";
  print("\n0 $word\n");
  for (var i = 1; i <= 10; i++) {
    word = permutation.cyclesPermuteString(word, cyclesThuFri);
    print("${i.toString().padLeft(2)} $word${i == 9 ? "\n" : ""}");
  }
}

enum Day implements Comparable<Day> {
  monday("HANDYCOILSERUPT"),
  tuesday("SPOILUNDERYACHT"),
  wednesday("DRAINSTYLEPOUCH"),
  thursday("DITCHSYRUPALONE"),
  friday("SOAPYTHIRDUNCLE"),
  saturday("SHINEPARTYCLOUD"),
  sunday("RADIOLUNCHTYPES");

  final String letters;
  static final SplayTreeSet<Day> days = SplayTreeSet<Day>.of(Day.values);

  const Day(this.letters);

  @override
  int compareTo(Day other) {
    return index.compareTo(other.index);
  }

  Day previous() {
    final previousDay = days.lastWhere((day) => day.index < this.index, orElse: () => days.last);
    return previousDay;
  }
}

class Permutation {
  final int lettersCount;

  Permutation(this.lettersCount);

  List<int> createOneLine(String source, String destination) {
    final result = <int>[];
    for (final ch in destination.split('')) {
      result.add(source.indexOf(ch) + 1);
    }

    while (result.isNotEmpty && result.last == result.length) {
      result.removeLast();
    }
    return result;
  }

  List<List<int>> oneLineToCycles(List<int> oneLine) {
    final cycles = <List<int>>[];
    final used = <int>{};

    for (var number = 1; used.length < oneLine.length; number++) {
      if (!used.contains(number)) {
        final index = oneLine.indexOf(number) + 1;

        if (index > 0) {
          final cycle = <int>[];
          cycle.add(number);

          var currentIndex = index;
          while (number != currentIndex) {
            cycle.add(currentIndex);
            currentIndex = oneLine.indexOf(currentIndex) + 1;
          }

          if (cycle.length > 1) {
            cycles.add(cycle);
          }
          used.addAll(cycle);
        }
      }
    }

    return cycles;
  }

  List<int> cyclesToOneLine(List<List<int>> cycles) {
    final oneLine = List<int>.generate(lettersCount, (index) => index + 1);
    for (var number = 1; number <= lettersCount; number++) {
      for (final cycle in cycles) {
        final index = cycle.indexOf(number);
        if (index >= 0) {
          oneLine[number - 1] = cycle[(index - 1 + cycle.length) % cycle.length];
          break;
        }
      }
    }

    return oneLine;
  }

  List<List<int>> cyclesInverse(List<List<int>> cycles) {
    final cyclesInverse = cycles.map((list) => List<int>.from(list)).toList();
    for (var i = 0; i < cyclesInverse.length; i++) {
      final cycle = cyclesInverse[i];
      final firstElement = cycle.removeAt(0);
      cycle.add(firstElement);
      cyclesInverse[i] = cycle.reversed.toList();
    }

    return cyclesInverse;
  }

  List<int> oneLineInverse(List<int> oneLine) {
    final oneLineInverse = List<int>.filled(oneLine.length, 0);
    for (var number = 1; number <= oneLine.length; number++) {
      oneLineInverse[number - 1] = oneLine.indexOf(number) + 1;
    }

    return oneLineInverse;
  }

  List<List<int>> combinedCycles(List<List<int>> cyclesOne, List<List<int>> cyclesTwo) {
    final combinedCycles = <List<int>>[];
    final used = <int>{};

    for (var number = 1; used.length < lettersCount; number++) {
      if (!used.contains(number)) {
        var combined = next(next(number, cyclesOne), cyclesTwo);
        final cycle = <int>[];
        cycle.add(number);

        while (number != combined) {
          cycle.add(combined);
          combined = next(next(combined, cyclesOne), cyclesTwo);
        }

        if (cycle.length > 1) {
          combinedCycles.add(cycle);
        }
        used.addAll(cycle);
      }
    }

    return combinedCycles;
  }

  String oneLinePermuteString(String text, List<int> oneLine) {
    final permuted = <String>[];

    for (final index in oneLine) {
      permuted.add(text.substring(index - 1, index));
    }
    permuted.add(text.substring(permuted.length));

    return permuted.join();
  }

  String cyclesPermuteString(String text, List<List<int>> cycles) {
    final permuted = text.split('');

    for (final cycle in cycles) {
      for (final number in cycle) {
        permuted[next(number, cycles) - 1] = text.substring(number - 1, number);
      }
    }

    return permuted.join();
  }

  String signature(List<int> oneLine) {
    final cycles = oneLineToCycles(oneLine);

    final evenCount = cycles.where((list) => list.length % 2 == 0).length;

    return evenCount % 2 == 0 ? "+1" : "-1";
  }

  int order(List<int> oneLine) {
    final cycles = oneLineToCycles(oneLine);
    final sizes = cycles.map((list) => list.length).toList();

    return sizes.reduce((one, two) => one * (two ~/ gcd(one, two)));
  }

  int next(int number, List<List<int>> cycles) {
    for (final cycle in cycles) {
      if (cycle.contains(number)) {
        return cycle[(cycle.indexOf(number) + 1) % cycle.length];
      }
    }

    return number;
  }

  int gcd(int one, int two) {
    return two == 0 ? one : gcd(two, one % two);
  }
}

