String str = "I am a string";
if (str.matches(".*string")) { // note: matches() tests if the entire string is a match
  System.out.println("ends with 'string'");
}
