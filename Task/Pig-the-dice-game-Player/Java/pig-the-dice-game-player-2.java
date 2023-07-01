public class Player {

	private int points = 0;
	private int turnPoints = 0;
	private Strategy strategy = null;
	private int max = 0;
	private int number;
	private int iter = 0;
	
	public Player(int val) {
		number = val;
	}
	
	public int getPoints() {
		return points;
	}
	public int getTurnPoints() {
		return turnPoints;
	}
	public int getMax() {
		return max;
	}
	public int getNumber() {
		return number;
	}
	public int getIter() {
		return iter;
	}
	public void addPoints(int val) {
		points += val;
	}
	public void setTurnPoints(int val) {
		turnPoints = val;
	}
	public void setStrategy(Strategy strat) {
		strategy = strat;
	}
	public void setMax(int val) {
		max = val;
	}
	public void setNumber(int val) {
		number = val;
	}
	public void resetIter() {
		iter = 0;
	}
	public void incIter() {
		iter++;
	}
	public void aiIntro() {
		System.out.println("   Player " + getNumber() + "'s turn points are " + getTurnPoints() + ". Their total is " + getPoints() + ". ");
		System.out.println("   The max points any player currently has is " + getMax() + ". ");
	}
	public Move choose() {
		return strategy.choose(this);
	}

}
