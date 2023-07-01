public static boolean isNumeric(String inputData) {
  NumberFormat formatter = NumberFormat.getInstance();
  ParsePosition pos = new ParsePosition(0);
  formatter.parse(inputData, pos);
  return inputData.length() == pos.getIndex();
}
