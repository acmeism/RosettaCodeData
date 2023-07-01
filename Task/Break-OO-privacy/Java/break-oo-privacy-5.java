Example example = new Example();
Field field = example.getClass().getDeclaredField("stringB");
field.setAccessible(true);
String stringA = example.stringA;
String stringB = (String) field.get(example);
System.out.println(stringA + " " + stringB);
