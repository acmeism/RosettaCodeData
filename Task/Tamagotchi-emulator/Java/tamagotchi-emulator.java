import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.Scanner;

class Tamagotchi {
	public String name;
	public int age,bored,food,poop;
	
}

public class TamagotchiGame {
	Tamagotchi tama;//current Tamagotchi
	Random random = new Random(); // pseudo random number generator
	
	String[] verbs = {
			"Ask", "Ban", "Bash", "Bite", "Break", "Build",
		    "Cut", "Dig", "Drag", "Drop", "Drink", "Enjoy",
		    "Eat", "End", "Feed", "Fill", "Force", "Grasp",
		    "Gas", "Get", "Grab", "Grip", "Hoist", "House",
		    "Ice", "Ink", "Join", "Kick", "Leave", "Marry",
		    "Mix", "Nab", "Nail", "Open", "Press", "Quash",
		    "Rub", "Run", "Save", "Snap", "Taste", "Touch",
		    "Use", "Vet", "View", "Wash", "Xerox", "Yield",
	};
	
	String[] nouns = {
			"arms", "bugs", "boots", "bowls", "cabins", "cigars",
		    "dogs", "eggs", "fakes", "flags", "greens", "guests",
		    "hens", "hogs", "items", "jowls", "jewels", "juices",
		    "kits", "logs", "lamps", "lions", "levers", "lemons",
		    "maps", "mugs", "names", "nests", "nights", "nurses",
		    "orbs", "owls", "pages", "posts", "quests", "quotas",
		    "rats", "ribs", "roots", "rules", "salads", "sauces",
		    "toys", "urns", "vines", "words", "waters", "zebras",
	};
	
	String[] boredIcons = {"💤", "💭", "❓"};
	String[] foodIcons = {"🍼", "🍔", "🍟", "🍰", "🍜"};
	String[] poopIcons = {"💩"};
	String[] sickIcons1 = {"😄", "😃", "😀", "😊", "😎", "👍"};//ok
	String[] sickIcons2 = {"😪", "😥", "😰", "😓"};//ailing
	String[] sickIcons3 = {"😩", "😫"};//bad
	String[] sickIcons4 = {"😡", "😱"};//very bad
	String[] sickIcons5 = {"❌", "💀", "👽", "😇"};//dead
	
	String brace(String string) {
		return String.format("{ %s }", string);
	}
	
	void create(String name) {
		tama = new Tamagotchi();
		tama.name = name;
		tama.age = 0;
		tama.bored = 0;
		tama.food = 2;
		tama.poop = 0;
	}
	
	boolean alive() { // alive if sickness <= 10
		return sickness() <= 10;
	}
	
	void feed() {
		tama.food++;
	}
	
	void play() {//may or may not help with boredom
		tama.bored = Math.max(0, tama.bored - random.nextInt(2));
	}
	
	void talk() {
		String verb = verbs[random.nextInt(verbs.length)];
		String noun = nouns[random.nextInt(nouns.length)];
		System.out.printf("😮 : %s the %s.%n", verb, noun);
		tama.bored = Math.max(0, tama.bored - 1);
	}
	
	void clean() {
		tama.poop = Math.max(0, tama.poop - 1);
	}
	
	void idle() {//renamed from wait() due to wait being an existing method from the Object class
		tama.age++;
		tama.bored += random.nextInt(2);
		tama.food = Math.max(0, tama.food - 2);
		tama.poop += random.nextInt(2);
	}
	
	String status() {// get boredom/food/poop icons
		if(alive()) {
			StringBuilder b = new StringBuilder(),
					f = new StringBuilder(),
					p = new StringBuilder();
			for(int i = 0; i < tama.bored; i++) {
				b.append(boredIcons[random.nextInt(boredIcons.length)]);
			}
			for(int i = 0; i < tama.food; i++) {
				f.append(foodIcons[random.nextInt(foodIcons.length)]);
			}
			for(int i = 0; i < tama.poop; i++) {
				p.append(poopIcons[random.nextInt(poopIcons.length)]);
			}
			
			return String.format("%s  %s  %s", brace(b.toString()), brace(f.toString()), brace(p.toString()));
		}
		
		return " R.I.P";
	}
	
	//too much boredom/food/poop
	int sickness() {
		//dies at age 42 at the latest
		return tama.poop + tama.bored + Math.max(0, tama.age - 32) + Math.abs(tama.food - 2);
	}
	
	//get health status from sickness level
	void health() {
		int s = sickness();
		String icon;
		switch(s) {
		case 0:
		case 1:
		case 2:
			icon = sickIcons1[random.nextInt(sickIcons1.length)];
			break;
		case 3:
		case 4:
			icon = sickIcons2[random.nextInt(sickIcons2.length)];
			break;
		case 5:
		case 6:
			icon = sickIcons3[random.nextInt(sickIcons3.length)];
			break;
		case 7:
		case 8:
		case 9:
		case 10:
			icon = sickIcons4[random.nextInt(sickIcons4.length)];
			break;
		default:
			icon = sickIcons5[random.nextInt(sickIcons5.length)];
			break;
		}
		
		System.out.printf("%s (🎂 %d)  %s %d  %s%n%n", tama.name, tama.age, icon, s, status());
	}
	
	void blurb() {
		System.out.println("When the '?' prompt appears, enter an action optionally");
		System.out.println("followed by the number of repetitions from 1 to 9.");
		System.out.println("If no repetitions are specified, one will be assumed.");
		System.out.println("The available options are: feed, play, talk, clean or wait.\n");
	}
	
	public static void main(String[] args) {
		TamagotchiGame game = new TamagotchiGame();
		game.random.setSeed(System.nanoTime());
		
		System.out.println("         TAMAGOTCHI EMULATOR");
		System.out.println("         ===================\n");
		
		Scanner scanner = new Scanner(System.in);
		System.out.print("Enter the name of your tamagotchi : ");
		String name = scanner.nextLine().toLowerCase().trim();
		
		game.create(name);
		System.out.printf("%n%s (age) health {bored} {food}    {poop}%n%n", "name");
		game.health();
		game.blurb();
		
		ArrayList<String> commands = new ArrayList<>(List.of("feed", "play", "talk", "clean", "wait"));
		
		int count = 0;
		while(game.alive()) {
			System.out.print("? ");
			String input = scanner.nextLine().toLowerCase().trim();
			String[] items = input.split(" ");
			if(items.length > 2) continue;
			
			String action = items[0];
			if(!commands.contains(action)) {
				continue;
			}
			
			int reps;
			if(items.length == 2) {
				reps = Integer.parseInt(items[1]);
			} else {
				reps = 1;
			}
			
			for(int i = 0; i < reps; i++) {
				switch(action) {
				case "feed":
					game.feed();
					break;
				case "play":
					game.play();
					break;
				case "talk":
					game.talk();
					break;
				case "wait":
					game.idle();
					break;
				}
				
				//simulate a wait on every third (non-wait) action
				if(!action.equals("wait")) {
					count++;
					if(count%3==0) {
						game.idle();
					}
				}
			}
			game.health();
		}
		
		scanner.close();
	}
}


