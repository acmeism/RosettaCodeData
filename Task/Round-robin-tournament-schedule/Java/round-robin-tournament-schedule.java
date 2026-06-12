import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class RoundRobinTournamentSchedule {

	public static void main(String[] args) {
		System.out.println("Round robin for 12 players:");
		roundRobin(12);
		System.out.println(System.lineSeparator());
		System.out.println("Round robin for 5 players, 0 denotes a bye:");
		roundRobin(5);
	}
	
	private static void roundRobin(int teamCount) {
		if ( teamCount < 2 ) {
			throw new IllegalArgumentException("Number of teams must be greater than 2: " + teamCount);
		}
		
		List<Integer> rotatingList = IntStream.rangeClosed(2, teamCount).boxed().collect(Collectors.toList());
		if ( teamCount % 2 == 1 ) {
		    rotatingList.add(0);
		    teamCount += 1;
		}
		
		for ( int round = 1; round < teamCount; round++ ) {
		    System.out.print(String.format("%s%2d%s", "Round ", round, ":"));
		    List<Integer> fixedList = IntStream.rangeClosed(1, 1).boxed().collect(Collectors.toList());
		    fixedList.addAll(rotatingList);
		    for ( int i = 0; i < teamCount / 2; i++ ) {
		    	System.out.print(String.format("%s%2d%s%2d%s",
		    		" ( ", fixedList.get(i), " vs ", fixedList.get(teamCount - 1 - i), " )"));
		    }
		    System.out.println();
		    Collections.rotate(rotatingList, +1);
		}
	}

}
