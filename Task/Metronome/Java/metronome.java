class Metronome{
	double bpm;
	int measure, counter;
	public Metronome(double bpm, int measure){
		this.bpm = bpm;
		this.measure = measure;	
	}
	public void start(){
		while(true){
			try {
				Thread.sleep((long)(1000*(60.0/bpm)));
			}catch(InterruptedException e) {
				e.printStackTrace();
			}
			counter++;
			if (counter%measure==0){
				 System.out.println("TICK");
			}else{
				 System.out.println("TOCK");
			}
		}
	}
}
public class test {
	public static void main(String[] args) {
		Metronome metronome1 = new Metronome(120,4);
		metronome1.start();
	}
}
