package jfkbits;

public class StringAtom extends Atom
{
    public String toString()
    {
        // StreamTokenizer hardcodes escaping with \, and doesn't allow \n inside words
        String escaped = name.replace("\\", "\\\\").replace("\n", "\\n").replace("\r", "\\r").replace("\"", "\\\"");
        return "\""+escaped+"\"";
    }

    public StringAtom(String text)
    {
        super(text);
    }
    public String getValue()
    {
        return name;
    }
}
