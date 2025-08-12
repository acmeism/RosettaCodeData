import 'dart:convert'; // for jsonEncode (used to mimic std::quoted)
import 'dart:io';

/// Prints a list of integers in the form `[1, 2, 3]`.
void display(List<int> numbers) {
  final joined = numbers.join(', ');
  print('[$joined]');
}

/// Returns the first index of `needle` inside `haystack`,
/// or -1 if `needle` cannot be found.
int stringSearchSingle(String haystack, String needle) {
  final idx = haystack.indexOf(needle);
  return idx >= 0 ? idx : -1;
}

/// Returns **all** non‑overlapping start indexes of `needle` inside `haystack`.
List<int> stringSearch(String haystack, String needle) {
  final List<int> result = [];

  int start = 0;               // where we continue searching from
  int index = 0;               // result of the latest search

  // Keep searching while we still find matches and we haven’t run off the end.
  while (start < haystack.length && (index = stringSearchSingle(
          haystack.substring(start), needle)) >= 0) {
    final absoluteIdx = start + index;
    result.add(absoluteIdx);
    // Move past the match we just found so the next search starts after it.
    start = absoluteIdx + needle.length;
  }

  return result;
}

void main() {
  // ---------------------------------------------------------------------------
  // 1️⃣  The data (identical to the C++ version)
  // ---------------------------------------------------------------------------
  const List<String> texts = [
    "GCTAGCTCTACGAGTCTA",
    "GGCTATAATGCGTA",
    "there would have been a time for such a word",
    "needle need noodle needle",
    "DKnuthusesandprogramsanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguages",
    "Nearby farms grew an acre of alfalfa on the dairy's behalf, with bales of that alfalfa exchanged for milk."
  ];

  const List<String> patterns = [
    "TCTA",
    "TAATAAA",
    "word",
    "needle",
    "and",
    "alfalfa"
  ];

  // ---------------------------------------------------------------------------
  // 2️⃣  Print the original texts (mirrors the first loop in C++).
  // ---------------------------------------------------------------------------
  for (var i = 0; i < texts.length; ++i) {
    print('text${i + 1} = ${texts[i]}');
  }
  print(''); // blank line like the C++ program

  // ---------------------------------------------------------------------------
  // 3️⃣  Search each pattern in its corresponding text and print the results.
  // ---------------------------------------------------------------------------
  for (var i = 0; i < texts.length; ++i) {
    final List<int> indexes = stringSearch(texts[i], patterns[i]);

    // `jsonEncode` adds double quotes around a string and escapes characters,
    // which behaves like `std::quoted` in C++.
    final quotedPattern = jsonEncode(patterns[i]);

    stdout.write(
        'Found $quotedPattern in \'text${i + 1}\' at indexes ');
    display(indexes);
  }
}
