package intersectingNumberWheels;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;

public class WheelController {
	private static final String IS_NUMBER = "[0-9]";
	private static final int TWENTY = 20;
	private static Map<String, WheelModel> wheelMap;

	public static void advance(String wheel) {
		WheelModel w = wheelMap.get(wheel);
		if (w.list.get(w.position).matches(IS_NUMBER)) {
			w.printThePosition();
			w.advanceThePosition();
		} else {
			String wheelName = w.list.get(w.position);
			advance(wheelName);
			w.advanceThePosition();
		}
	}

	public static void run() {
		System.out.println(wheelMap);
		IntStream.rangeClosed(1, TWENTY).forEach(i -> advance("A"));
		System.out.println();
		wheelMap.clear();
	}

	public static void main(String[] args) {
		wheelMap = new HashMap<>();
		wheelMap.put("A", new WheelModel("A", "1", "2", "3"));
		run();
		wheelMap.put("A", new WheelModel("A", "1", "B", "2"));
		wheelMap.put("B", new WheelModel("B", "3", "4"));
		run();
		wheelMap.put("A", new WheelModel("A", "1", "D", "D"));
		wheelMap.put("D", new WheelModel("D", "6", "7", "8"));
		run();
		wheelMap.put("A", new WheelModel("A", "1", "B", "C"));
		wheelMap.put("B", new WheelModel("B", "3", "4"));
		wheelMap.put("C", new WheelModel("C", "5", "B"));
		run();
	}

}

class WheelModel {
	String name;
	List<String> list;
	int position;
	int endPosition;
	private static final int INITIAL = 0;

	public WheelModel(String name, String... values) {
		super();

		this.name = name.toUpperCase();
		this.list = new ArrayList<>();
		for (String value : values) {
			list.add(value);
		}
		this.position = INITIAL;
		this.endPosition = this.list.size() - 1;
	}

	@Override
	public String toString() {
		return list.toString();
	}

	public void advanceThePosition() {
		if (this.position == this.endPosition) {
			this.position = INITIAL;// new beginning
		} else {
			this.position++;// advance position
		}
	}

	public void printThePosition() {
		System.out.print(" " + this.list.get(position));
	}
}
