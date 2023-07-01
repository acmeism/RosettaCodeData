public abstract class Animal : Object {
  public void eat() {
    print("Chomp! Chomp!\n");
  }

  public abstract void talk();
}

public class Mouse : Animal {
  public override void talk() {
    print("Squeak! Squeak!\n");
  }
}

public class Dog : Animal {
  public override void talk() {
    print("Woof! Woof!\n");
  }
}

void main() {
  Dog mike = new Dog();
  Mouse scott = new Mouse();

  mike.talk();
  mike.eat();
  scott.talk();
  scott.eat();
}
