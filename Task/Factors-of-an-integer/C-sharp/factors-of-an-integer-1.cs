static void Main (string[] args) {
    do {
        Console.WriteLine ("Number:");
        Int64 p = 0;
        do {
            try {
                p = Convert.ToInt64 (Console.ReadLine ());
                break;
            } catch (Exception) { }

        } while (true);

        Console.WriteLine ("For 1 through " + ((int) Math.Sqrt (p)).ToString () + "");
        for (int x = 1; x <= (int) Math.Sqrt (p); x++) {
            if (p % x == 0)
                Console.WriteLine ("Found: " + x.ToString () + ". " + p.ToString () + " / " + x.ToString () + " = " + (p / x).ToString ());
        }

        Console.WriteLine ("Done.");
    } while (true);
}
