import java.util.ArrayList;
import java.util.List;

public final class FunctionalCoverageTree {

	public static void main(String[] aArgs) {		
		FCNode cleaning = new FCNode("Cleaning", 1, 0.0);
		
		List<FCNode> houses = List.of(
			new FCNode("House_1", 40, 0.0),
			new FCNode("House_2", 60, 0.0) );		
		cleaning.addChildren(houses);
		
		List<FCNode> house_1 = List.of(
			new FCNode("Bedrooms", 1, 0.25),
			new FCNode("Bathrooms", 1, 0.0),
			new FCNode("Attic", 1, 0.75),
			new FCNode("Kitchen", 1, 0.1),
			new FCNode("Living_rooms", 1, 0.0),
			new FCNode("Basement", 1, 0.0),
			new FCNode("Garage", 1, 0.0),
			new FCNode("Garden",1, 0.8) );		
		houses.get(0).addChildren(house_1);
		
		List<FCNode> bathrooms_house_1 = List.of(
			new FCNode("Bathroom_1", 1, 0.5),
			new FCNode("Bathroom_2", 1, 0.0),
			new FCNode("Outside_lavatory", 1, 1.0) );
		house_1.get(1).addChildren(bathrooms_house_1);
		
		List<FCNode> living_rooms_house_1 = List.of(
			new FCNode("lounge", 1, 0.0),
			new FCNode("Dining_room", 1, 0.0),
			new FCNode("Conservatory", 1, 0.0),
			new FCNode("Playroom", 1, 1.0) );
		house_1.get(4).addChildren(living_rooms_house_1);
		
		List<FCNode> house_2 = List.of(
			new FCNode("Upstairs", 1, 0.15),
			new FCNode("Ground_floor", 1, 0.316667),
			new FCNode("Basement", 1, 0.916667));
		houses.get(1).addChildren(house_2);
		
		List<FCNode> upstairs = List.of(
			new FCNode("Bedrooms", 1, 0.0),
			new FCNode("Bathroom", 1, 0.0),
			new FCNode("Toilet", 1, 0.0),
			new FCNode("Attics", 1, 0.6) );
		house_2.get(0).addChildren(upstairs);
		
		List<FCNode> ground_floor = List.of(
			new FCNode("Kitchen", 1, 0.0),
			new FCNode("Living_rooms", 1, 0.0),
			new FCNode("Wet_room_&_toilet", 1, 0.0),
			new FCNode("Garage", 1, 0.0),
			new FCNode("Garden", 1, 0.9),
			new FCNode("Hot_tub_suite", 1, 1.0) );
		house_2.get(1).addChildren(ground_floor);
		
		List<FCNode> basement = List.of(
			new FCNode("Cellars", 1, 1.0),
			new FCNode("Wine_cellar", 1, 1.0),
			new FCNode("Cinema", 1, 0.75) );
		house_2.get(2).addChildren(basement);
		
		List<FCNode> bedrooms = List.of(
			new FCNode("Suite_1", 1, 0.0),
			new FCNode("Suite_2", 1, 0.0),
			new FCNode("Bedroom_3",1, 0.0),
			new FCNode("Bedroom_4",1, 0.0) );
		upstairs.get(0).addChildren(bedrooms);
		
		List<FCNode> living_rooms_house_2 = List.of(
			new FCNode("lounge", 1, 0.0),
			new FCNode("Dining_room", 1, 0.0),
			new FCNode("Conservatory", 1, 0.0),
			new FCNode("Playroom", 1, 0.0) );
		ground_floor.get(1).addChildren(living_rooms_house_2);		
		
		final double overallCoverage = cleaning.getCoverage();
		System.out.println("OVERALL COVERAGE = " + String.format("%.6f", overallCoverage));
        System.out.println();
		System.out.println("NAME HIERARCHY                  | WEIGHT | COVERAGE |" );
		System.out.println("--------------------------------|--------|----------|");
		cleaning.display();
		System.out.println();
		
		basement.get(2).setCoverage(1.0); // Change House_2 Cinema node coverage to 1.0		
		final double updatedCoverage = cleaning.getCoverage();
	    final double difference = updatedCoverage - overallCoverage;
	    System.out.println("If the coverage of the House_2 Cinema node were increased from 0.75 to 1.0");
	    System.out.print("the overall coverage would increase by ");
	    System.out.println(String.format("%.6f%s%.6f", difference, " to ", updatedCoverage));;
	    basement.get(2).setCoverage(0.75); // Restore to House_2 Cinema node coverage to its original value
	}

}

final class FCNode {
	
	public FCNode(String aName, int aWeight, double aCoverage) {
		name = aName;
		weight = aWeight;
		coverage = aCoverage;
	}
	
	public void addChildren(List<FCNode> aNodes) {
	    for ( FCNode node : aNodes ) {
	    	node.parent = this;
	    	children.add(node);
	    	updateCoverage();
	    }
	}	
	
	public double getCoverage() {
		return coverage;
	}
	
	public void setCoverage(double aCoverage) {
		if ( coverage != aCoverage ) {
		    coverage = aCoverage;
		    if ( parent != null ) {
		    	parent.updateCoverage();
		    }
		}		
	}
	
	public void display() {
		display(0);
	}
	
	private void updateCoverage() {
		double sumWeightedCoverage = 0.0;
	    int sumWeight = 0;
	    for ( FCNode node : children ) {
	    	sumWeightedCoverage += node.weight * node.coverage;
	    	sumWeight += node.weight;
	    }
	
	    setCoverage(sumWeightedCoverage / sumWeight);
	}	
	
	private void display(int aLevel) {		
		final String initial = " ".repeat(4 * aLevel) + name;
		final String padding = " ".repeat(NAME_FIELD_WIDTH - initial.length());
		System.out.print(initial + padding + "|");
		System.out.print("  " + String.format("%3d", weight) + "   |");
		System.out.println(" " + String.format("%.6f", coverage) + " |");

		for ( FCNode child : children ) {
			child.display(aLevel + 1);
		}
	}	
	
	private String name;
	private int weight;
	private double coverage;
	private FCNode parent;
	private List<FCNode> children = new ArrayList<FCNode>();
	
	private static final int NAME_FIELD_WIDTH = 32;
	
}
