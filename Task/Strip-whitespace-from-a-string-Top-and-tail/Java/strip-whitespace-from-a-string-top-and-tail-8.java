    public static String ltrim(String s) {
        int offset = 0;
        while (offset < s.length()) {
            int codePoint = s.codePointAt(offset);
            if (!Character.isWhitespace(codePoint)) break;
            offset += Character.charCount(codePoint);
        }
        return s.substring(offset);
    }

    public static String rtrim(String s) {
        int offset = s.length();
        while (offset > 0) {
            int codePoint = s.codePointBefore(offset);
            if (!Character.isWhitespace(codePoint)) break;
            offset -= Character.charCount(codePoint);
        }
        return s.substring(0, offset);
    }
