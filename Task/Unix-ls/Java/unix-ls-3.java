Files.list(Path.of("")).map(Path::toString).sorted(String.CASE_INSENSITIVE_ORDER).forEach(System.out::println);
