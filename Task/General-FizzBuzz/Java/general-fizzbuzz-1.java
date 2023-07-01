public class FizzBuzz {

    public static void main(String[] args) {
        Sound[] sounds = {new Sound(3, "Fizz"), new Sound(5, "Buzz"),  new Sound(7, "Baxx")};
        for (int i = 1; i <= 20; i++) {
            StringBuilder sb = new StringBuilder();
            for (Sound sound : sounds) {
                sb.append(sound.generate(i));
            }
            System.out.println(sb.length() == 0 ? i : sb.toString());
        }
    }

    private static class Sound {
        private final int trigger;
        private final String onomatopoeia;

        public Sound(int trigger, String onomatopoeia) {
            this.trigger = trigger;
            this.onomatopoeia = onomatopoeia;
        }

        public String generate(int i) {
            return i % trigger == 0 ? onomatopoeia : "";
        }

    }

}
