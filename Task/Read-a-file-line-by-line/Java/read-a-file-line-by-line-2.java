for (String filename : args) {
    try (FileReader fr = new FileReader(filename);BufferedReader br = new BufferedReader(fr)){
        String line;
        int lineNo = 0;
        while ((line = br.readLine()) != null) {
            processLine(++lineNo, line);
        }
    }
    catch (Exception x) {
        x.printStackTrace();
    }
}
