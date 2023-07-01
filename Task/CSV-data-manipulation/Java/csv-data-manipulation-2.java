public class CSV {
    public static void main(String[] args) throws IOException {
        CSV csv = new CSV("data.csv");
        csv.sumAllRows();
        csv.write();
    }

    private final File file;
    private List<List<String>> data;

    public CSV(File file) throws IOException {
        this.file = file;
        open();
    }

    /* convenience constructor */
    public CSV(String path) throws IOException {
        this(new File(path));
    }

    public void sumAllRows() {
        appendColumn("SUM");
        int sum;
        int length;
        for (int index = 1; index < data.size(); index++) {
            sum = sum(data.get(index));
            length = data.get(index).size();
            data.get(index).set(length - 1, String.valueOf(sum));
        }
    }

    private int sum(List<String> row) {
        int sum = 0;
        for (int index = 0; index < row.size() - 1; index++)
            sum += Integer.parseInt(row.get(index));
        return sum;
    }

    private void appendColumn(String title) {
        List<String> titles = data.get(0);
        titles.add(title);
        /* append an empty cell to each row */
        for (int index = 1; index < data.size(); index++)
            data.get(index).add("");
    }

    private void open() throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            data = new ArrayList<>();
            String line;
            while ((line = reader.readLine()) != null) {
                /* using a limit of -1 will preserve trailing commas */
                data.add(new ArrayList<>(List.of(line.split(",", -1))));
            }
        }
    }

    public void write() throws IOException {
        try (FileWriter writer = new FileWriter(file)) {
            String newline = System.lineSeparator();
            for (List<String> row : data) {
                writer.write(String.join(",", row));
                writer.write(newline);
            }
            writer.flush();
        }
    }
}
