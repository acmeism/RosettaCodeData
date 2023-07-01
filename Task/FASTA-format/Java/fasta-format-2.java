public static void main(String[] args) throws IOException {
    List<FASTA> fastas = readFile("fastas.txt");
    for (FASTA fasta : fastas)
        System.out.println(fasta);
}

static List<FASTA> readFile(String path) throws IOException {
    try (BufferedReader reader = new BufferedReader(new FileReader(path))) {
        List<FASTA> list = new ArrayList<>();
        StringBuilder lines = null;
        String newline = System.lineSeparator();
        String line;
        while ((line = reader.readLine()) != null) {
            if (line.startsWith(">")) {
                if (lines != null)
                    list.add(parseFASTA(lines.toString()));
                lines = new StringBuilder();
                lines.append(line).append(newline);
            } else {
                lines.append(line);
            }
        }
        list.add(parseFASTA(lines.toString()));
        return list;
    }
}

static FASTA parseFASTA(String string) {
    String description;
    char[] sequence;
    int indexOf = string.indexOf(System.lineSeparator());
    description = string.substring(1, indexOf);
    /* using 'stripLeading' will remove any additional line-separators */
    sequence = string.substring(indexOf + 1).stripLeading().toCharArray();
    return new FASTA(description, sequence);
}

/* using a 'char' array seems more logical */
record FASTA(String description, char[] sequence) {
    @Override
    public String toString() {
        return "%s: %s".formatted(description, new String(sequence));
    }
}
