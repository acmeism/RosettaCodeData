public boolean isNumeric(String input) {
  try {
    Integer.parseInt(input);
    return true;
  }
  catch (NumberFormatException e) {
    // s is not numeric
    return false;
  }
}
