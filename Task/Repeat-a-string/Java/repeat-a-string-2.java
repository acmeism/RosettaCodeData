String[] strings = new String[5];
Arrays.fill(strings, "ha");
StringBuilder repeated = new StringBuilder();
for (String string : strings)
    repeated.append(string);
