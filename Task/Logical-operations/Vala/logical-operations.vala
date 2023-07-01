public class Program {
    private static void print_logic (bool a, bool b) {
        print ("a and b is %s\n", (a && b).to_string ());
        print ("a or b is %s\n", (a || b).to_string ());
        print ("not a %s\n", (!a).to_string ());
    }
    public static int main (string[] args) {
        if (args.length < 3) error ("Provide 2 arguments!");
        bool a = bool.parse (args[1]);
        bool b = bool.parse (args[2]);
        print_logic (a, b);
        return 0;
    }
}
