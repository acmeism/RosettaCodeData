import java.util.*;

public class FiniteStateMachine {

    private enum State {
        Ready(true, "Deposit", "Quit"),
        Waiting(true, "Select", "Refund"),
        Dispensing(true, "Remove"),
        Refunding(false, "Refunding"),
        Exiting(false, "Quiting");

        State(boolean exp, String... in) {
            inputs = Arrays.asList(in);
            explicit = exp;
        }

        State nextState(String input, State current) {
            if (inputs.contains(input)) {
                return map.getOrDefault(input, current);
            }
            return current;
        }

        final List<String> inputs;
        final static Map<String, State> map = new HashMap<>();
        final boolean explicit;

        static {
            map.put("Deposit", State.Waiting);
            map.put("Quit", State.Exiting);
            map.put("Select", State.Dispensing);
            map.put("Refund", State.Refunding);
            map.put("Remove", State.Ready);
            map.put("Refunding", State.Ready);
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        State state = State.Ready;

        while (state != State.Exiting) {
            System.out.println(state.inputs);
            if (state.explicit){
                System.out.print("> ");
                state = state.nextState(sc.nextLine().trim(), state);
            } else {
                state = state.nextState(state.inputs.get(0), state);
            }
        }
    }
}
