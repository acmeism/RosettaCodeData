void printContent(String address) throws URISyntaxException, IOException {
    URL url = new URI(address).toURL();
    try (BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream()))) {
        String line;
        while ((line = reader.readLine()) != null)
            System.out.println(line);
    }
}
