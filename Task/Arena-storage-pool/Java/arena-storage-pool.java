import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

public final class ArenaStoragePool {

	public static void main(String[] args) {
		List<Object> storagePool = new ArrayList<Object>();
		storagePool.addLast(42);
		storagePool.addLast("Hello World");
		storagePool.addFirst(BigInteger.ZERO);
		
		System.out.println(storagePool);
		
		storagePool = null;
		System.gc();		
	}

}
