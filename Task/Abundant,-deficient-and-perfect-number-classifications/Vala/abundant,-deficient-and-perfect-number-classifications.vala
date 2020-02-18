enum Classification {
  DEFICIENT,
  PERFECT,
  ABUNDANT
}

void main() {
  var i = 0; var j = 0;
  var sum = 0; var try_max = 0;
  int[] count_list = {1, 0, 0};
  for (i = 2; i <= 20000; i++) {
    try_max = i / 2;
    sum = 1;
    for (j = 2; j < try_max; j++) {
      if (i % j != 0)
        continue;
      try_max = i / j;
      sum += j;
      if (j != try_max)
        sum += try_max;
    }
    if (sum < i) {
      count_list[Classification.DEFICIENT]++;
      continue;
    }
    if (sum > i) {
      count_list[Classification.ABUNDANT]++;
      continue;
    }
    count_list[Classification.PERFECT]++;
  }
  print(@"There are $(count_list[Classification.DEFICIENT]) deficient,");
  print(@" $(count_list[Classification.PERFECT]) perfect,");
  print(@" $(count_list[Classification.ABUNDANT]) abundant numbers between 1 and 20000.\n");
}
