public static void main(String[] args) throws IOException {

        // 1st, config the CSV reader with line separator
        CsvParserSettings settings = new CsvParserSettings();
        settings.getFormat().setLineSeparator("\n");

        // 2nd, config the CSV reader with row processor attaching the bean definition
        BeanListProcessor<Employee> rowProcessor = new BeanListProcessor<Employee>(Employee.class);
        settings.setRowProcessor(rowProcessor);

        // 3rd, creates a CSV parser with the configs
        CsvParser parser = new CsvParser(settings);

        // 4th, parse all rows from the CSF file into the list of beans you defined
        parser.parse(new FileReader("/examples/employees.csv"));
        List<Employee> resolvedBeans = rowProcessor.getBeans();

        // 5th, Store, Delete duplicates, Re-arrange the words in specific order
        // ......

        // 6th, Write the listed of processed employee beans out to a CSV file.
        CsvWriterSettings writerSettings = new CsvWriterSettings();

        // 6.1 Creates a BeanWriterProcessor that handles annotated fields in the Employee class.
        writerSettings.setRowWriterProcessor(new BeanWriterProcessor<Employee>(Employee.class));

        // 6.2 persistent the employee beans to a CSV file.
        CsvWriter writer = new CsvWriter(new FileWriter("/examples/processed_employees.csv"), writerSettings);
        writer.processRecords(resolvedBeans);
        writer.writeRows(new ArrayList<List<Object>>());
    }
