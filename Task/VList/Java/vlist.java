import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class VListTask {

	public static void main(String[] args) {
		VList<Integer> vList = new VList<Integer>();
	    System.out.println("Before adding any elements, the VList is empty: " + vList);
	    vList.showStructure();
	
	    for ( int i = 6; i >= 1; i-- ) {
	    	vList = vList.cons(i);
	    }
	    System.out.println("Demonstrating cons method, 6 elements added: " + vList);
	    vList.showStructure();
	
	    vList = vList.cdr();
		System.out.println("Demonstrating cdr method, 1 element removed: " + vList);
		vList.showStructure();
		
		System.out.println("Demonstrating size property, size = " + vList.size() + "\n");
		System.out.println("Demonstrating element access, v[3] = " + vList.get(3) + "\n");
		
		vList = vList.cdr().cdr();
		System.out.println("Demonstrating cdr method again, 2 more elements removed: " + vList);
		vList.showStructure();
	}
}

final class VList<T> {
	
	public VList() {
		base = new VSegment<T>();
		base.elements = new ArrayList<T>();
		offset = 0;
	}
	
	// Add an element to the beginning of this VList
    public VList<T> cons(T element) {      	
        if ( base.elements.isEmpty() ) {
         	base.elements.addLast(element);
        	return this;
        }

        if ( offset == 0 ) {
    		offset = base.elements.size() * 2 - 1;
            VSegment<T> segment = new VSegment<T>();
            segment.next = base;
            segment.elements = new ArrayList<T>(Collections.nCopies(offset, null));
            segment.elements.addLast(element);
        	base = segment;
        	return this;
        }

        offset -= 1;
        base.elements.set(offset, element);
        return this;
    }	

    // Return a new VList beginning at the second element this VLIst
    public VList<T> cdr() {
        if ( base.elements.isEmpty() ) {
        	throw new AssertionError("cdr invoked on an empty VList");
        }

        offset += 1;
        if ( offset < base.elements.size() ) {
        	return this;
        }

        offset = 0;
        base = base.next;
        return this;
    }

    // Return the element located at the given index
    public T get(int key) {
	    if ( key >= 0 ) {
	        int index = key + offset;
	        VSegment<T> segment = base;
	        while ( segment != null ) {
	        	if ( index < segment.elements.size() ) {
	        		return segment.elements.get(index);
	        	}
	        	
	        	index -= segment.elements.size();
	        	segment = segment.next;
	        }
	    }
	
	    throw new IllegalArgumentException("Index out of range: " + key);
    }

    // Return the size of this VList
    public int size() {
        return base.elements.isEmpty() ? 0 : base.elements.size() * 2 - offset - 1;
    }

    public String toString() {
    	if ( base.elements.isEmpty() ) {
    		return "[]";
    	}
    	
        StringBuilder result = new StringBuilder("[" + base.elements.get(offset));
        VSegment<T> segment = base;
        List<T> elementsSublist = base.elements.subList(offset + 1, base.elements.size());

        while ( true ) {
            for ( T element : elementsSublist ) {
            	result.append(" " + element);
            }
            segment = segment.next;
            if ( segment == null ) {
            	break;
            }
            elementsSublist = segment.elements;
        }
        result.append("]");
        return result.toString();
    }

    public void showStructure() {    	
        System.out.println("Offset: " + offset);
        VSegment<T> segment = base;
        while ( segment != null ) {
        	System.out.println(segment.elements);
        	segment = segment.next;
        }
        System.out.println();
    }
	
	private static final class VSegment<T> {
		
        private VSegment<T> next;
        private List<T> elements;

    }

    private VSegment<T> base;
    private int offset;
	
}
