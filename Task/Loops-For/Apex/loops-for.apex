for (Integer i = 0; i < 5; i++) {
    String line = '';

    for (Integer j = 0; j < i; j++) {
        line += '*';
    }

    System.debug(line);
}

List<String> lines = new List<String> {
    '*',
    '**',
    '***',
    '****',
    '*****'
};

for (String line : lines) {
    System.debug(line);
}
