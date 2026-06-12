public static void main(String[] args) throws IOException {
    double[] percentages = parseUtilization(procStat());
    System.out.printf("%-10s %5.2f%%%n", "idle", percentages[0] * 100);
    System.out.printf("%-10s %5.2f%%", "not-idle", percentages[1] * 100);
}

static String procStat() throws IOException {
    File file = new File("/proc/stat");
    try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
        return reader.readLine();
    }
}

/** @return idle and not-idle percentage values */
static double[] parseUtilization(String string) {
    string = string.substring(4).stripLeading();
    int total = 0;
    double idle = 0;
    double notIdle;
    int index = 0;
    for (String value : string.split(" ")) {
        if (index == 3)
            idle = Integer.parseInt(value);
        total += Integer.parseInt(value);
        index++;
    }
    idle /= total;
    notIdle = 1 - idle;
    return new double[] { idle, notIdle };
}
