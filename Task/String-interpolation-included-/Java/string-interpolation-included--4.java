StringBuilder string = new StringBuilder();
Formatter formatter = new Formatter(string);
String adjective = "little";
formatter.format("Mary had a %s lamb", adjective);
formatter.flush();
