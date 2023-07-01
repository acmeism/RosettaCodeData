Example example = new Example();
Method method = example.getClass().getDeclaredMethod("stringB");
method.setAccessible(true);
String stringA = example.stringA;
String stringB = (String) method.invoke(example);
System.out.println(stringA + " " + stringB);
