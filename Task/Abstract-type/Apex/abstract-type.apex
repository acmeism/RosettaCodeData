// Interface
public interface PurchaseOrder {
    // All other functionality excluded
    Double discount();
}

// One implementation of the interface for customers
public class CustomerPurchaseOrder implements PurchaseOrder {
    public Double discount() {
        return .05;  // Flat 5% discount
    }
}


// Abstract Class
public abstract class AbstractExampleClass {
	protected abstract Integer abstractMethod();
}

// Complete the abstract class by implementing its abstract method
public class Class1 extends AbstractExampleClass {
	public override Integer abstractMethod() { return 5; }
}
