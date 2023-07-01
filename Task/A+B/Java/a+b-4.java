int sum(InputStream input) throws IOException {
    BufferedReader reader = new BufferedReader(new InputStreamReader(input));
    String line = reader.readLine();
    reader.close();
    /* split parameter here is a regex */
    String[] values = line.split(" +");
    int A = Integer.parseInt(values[0]);
    int B = Integer.parseInt(values[1]);
    return A + B;
}
