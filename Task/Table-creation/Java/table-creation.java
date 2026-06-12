import java.io.*;
import java.util.*;

public class StockTrans implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String date;
    private String trans;
    private String symbol;
    private int quantity;
    private float price;
    private boolean settled;

    public StockTrans(int id, String date, String trans, String symbol, int quantity, float price, boolean settled) {
        this.id = id;
        this.date = date;
        this.trans = trans;
        this.symbol = symbol;
        this.quantity = quantity;
        this.price = price;
        this.settled = settled;
    }

    public void save(String filename) throws IOException {
        List<StockTrans> transactions = new ArrayList<>();
        File file = new File(filename);
        if (file.exists()) {
            try {
                transactions = load(filename);
            } catch (ClassNotFoundException e) {
                System.err.println("Error loading transactions: " + e.getMessage());
            }
        }
        int newId = transactions.isEmpty() ? 1 : transactions.get(transactions.size() - 1).id + 1;
        this.id = newId;
        transactions.add(this);
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(filename))) {
            oos.writeObject(transactions);
        }
    }

    @SuppressWarnings("unchecked")
    public static List<StockTrans> load(String filename) throws IOException, ClassNotFoundException {
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(filename))) {
            return (List<StockTrans>) ois.readObject();
        }
    }

    @Override
    public String toString() {
        return String.format("%d  %s  %-4s  %-5s  %4d  %2.2f  %b",
                id, date, trans, symbol, quantity, price, settled);
    }

    public static void main(String[] args) {
        String filename = "stocks.db";
        StockTrans[] transactions = {
            new StockTrans(0, "2006-01-05", "BUY", "RHAT", 100, 35.14f, true),
            new StockTrans(0, "2006-03-28", "BUY", "IBM", 1000, 45f, true),
            new StockTrans(0, "2006-04-06", "SELL", "IBM", 500, 53f, true),
            new StockTrans(0, "2006-04-05", "BUY", "MSOFT", 1000, 72f, false)
        };

        try {
            for (StockTrans trans : transactions) {
                trans.save(filename);
            }

            List<StockTrans> loaded = load(filename);
            System.out.println("Id     Date    Trans  Sym    Qty  Price  Settled");
            System.out.println("------------------------------------------------");
            for (StockTrans st : loaded) {
                System.out.println(st);
            }
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}

