Map<String, Object> mapA = new LinkedHashMap<>();
mapA.put("name", "Rocket Skates");
mapA.put("price", 12.75);
mapA.put("color", "yellow");

Map<String, Object> mapB = new LinkedHashMap<>();
mapB.put("price", 15.25);
mapB.put("color", "red");
mapB.put("year", 1974);

Map<String, Object> mapC = new LinkedHashMap<>();
mapC.putAll(mapA);
mapC.putAll(mapB);
