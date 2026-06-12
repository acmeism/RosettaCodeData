public static void main(String[] args) {
    String[] strings = {
        "http://example.com/download.tar.gz",
        "CharacterModel.3DS",
        ".desktop",
        "document",
        "document.txt_backup",
        "/etc/pam.d/login",
    };
    for (String string : strings)
        System.out.println(extractExtension(string));
}

static String extractExtension(String string) {
    /* we can use the 'File' class to extract the file-name */
    File file = new File(string);
    String filename = file.getName();
    int indexOf = filename.lastIndexOf('.');
    if (indexOf != -1) {
        String extension = filename.substring(indexOf);
        /* and use a regex to match only valid extensions */
        if (extension.matches("\\.[A-Za-z\\d]+"))
            return extension;
    }
    return "";
}
