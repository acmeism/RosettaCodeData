import java.io.*;
import java.text.*;
import java.util.*;

public class SimpleDatabase {

    final static String filename = "simdb.csv";

    public static void main(String[] args) {
        if (args.length < 1 || args.length > 3) {
            printUsage();
            return;
        }

        switch (args[0].toLowerCase()) {
            case "add":
                addItem(args);
                break;
            case "latest":
                printLatest(args);
                break;
            case "all":
                printAll();
                break;
            default:
                printUsage();
                break;
        }
    }

    private static class Item implements Comparable<Item>{
        final String name;
        final String date;
        final String category;

        Item(String n, String d, String c) {
            name = n;
            date = d;
            category = c;
        }

        @Override
        public int compareTo(Item item){
            return date.compareTo(item.date);
        }

        @Override
        public String toString() {
            return String.format("%s,%s,%s%n", name, date, category);
        }
    }

    private static void addItem(String[] input) {
        if (input.length < 2) {
            printUsage();
            return;
        }
        List<Item> db = load();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String date = sdf.format(new Date());
        String cat = (input.length == 3) ? input[2] : "none";
        db.add(new Item(input[1], date, cat));
        store(db);
    }

    private static void printLatest(String[] a) {
        List<Item> db = load();
        if (db.isEmpty()) {
            System.out.println("No entries in database.");
            return;
        }
        Collections.sort(db);
        if (a.length == 2) {
            for (Item item : db)
                if (item.category.equals(a[1]))
                    System.out.println(item);
        } else {
            System.out.println(db.get(0));
        }
    }

    private static void printAll() {
        List<Item> db = load();
        if (db.isEmpty()) {
            System.out.println("No entries in database.");
            return;
        }
        Collections.sort(db);
        for (Item item : db)
            System.out.println(item);
    }

    private static List<Item> load() {
        List<Item> db = new ArrayList<>();
        try (Scanner sc = new Scanner(new File(filename))) {
            while (sc.hasNext()) {
                String[] item = sc.nextLine().split(",");
                db.add(new Item(item[0], item[1], item[2]));
            }
        } catch (IOException e) {
            System.out.println(e);
        }
        return db;
    }

    private static void store(List<Item> db) {
        try (FileWriter fw = new FileWriter(filename)) {
            for (Item item : db)
                fw.write(item.toString());
        } catch (IOException e) {
            System.out.println(e);
        }
    }

    private static void printUsage() {
         System.out.println("Usage:");
         System.out.println("  simdb cmd [categoryName]");
         System.out.println("  add     add item, followed by optional category");
         System.out.println("  latest  print last added item(s), followed by "
                 + "optional category");
         System.out.println("  all     print all");
         System.out.println("  For instance: add \"some item name\" "
                 + "\"some category name\"");
    }
}
