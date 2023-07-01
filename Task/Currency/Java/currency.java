import java.math.*;
import java.util.*;

public class Currency {
    final static String taxrate = "7.65";

    enum MenuItem {

        Hamburger("5.50"), Milkshake("2.86");

        private MenuItem(String p) {
            price = new BigDecimal(p);
        }

        public final BigDecimal price;
    }

    public static void main(String[] args) {
        Locale.setDefault(Locale.ENGLISH);

        MathContext mc = MathContext.DECIMAL128;

        Map<MenuItem, BigDecimal> order = new HashMap<>();
        order.put(MenuItem.Hamburger, new BigDecimal("4000000000000000"));
        order.put(MenuItem.Milkshake, new BigDecimal("2"));

        BigDecimal subtotal = BigDecimal.ZERO;
        for (MenuItem it : order.keySet())
            subtotal = subtotal.add(it.price.multiply(order.get(it), mc));

        BigDecimal tax = new BigDecimal(taxrate, mc);
        tax = tax.divide(new BigDecimal("100"), mc);
        tax = subtotal.multiply(tax, mc);

        System.out.printf("Subtotal: %20.2f%n", subtotal);
        System.out.printf("     Tax: %20.2f%n", tax);
        System.out.printf("   Total: %20.2f%n", subtotal.add(tax));
    }
}
