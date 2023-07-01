String scrapeUTC() throws URISyntaxException, IOException {
    String address = "http://tycho.usno.navy.mil/cgi-bin/timer.pl";
    URL url = new URI(address).toURL();
    try (BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream()))) {
        Pattern pattern = Pattern.compile("^.+? UTC");
        Matcher matcher;
        String line;
        while ((line = reader.readLine()) != null) {
            matcher = pattern.matcher(line);
            if (matcher.find())
                return matcher.group().replaceAll("<.+?>", "");
        }
    }
    return null;
}
