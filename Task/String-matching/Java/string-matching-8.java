int indexOf;
int offset = 0;
while ((indexOf = string.indexOf(suffix, offset)) != -1) {
    System.out.printf("'%s' @ %d to %d%n", suffix, indexOf, indexOf + suffix.length() - 1);
    offset = indexOf + 1;
}
