N.println(IntStream.rangeClosed(1, 100).filter(i -> Math.pow((int) Math.sqrt(i), 2) == i).boxed().join(", ", "Open Doors: ", ""));
