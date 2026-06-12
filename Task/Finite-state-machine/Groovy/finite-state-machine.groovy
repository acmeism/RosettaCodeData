class FiniteStateMachine {
    private enum State {
        Ready(true, "Deposit", "Quit"),
        Waiting(true, "Select", "Refund"),
        Dispensing(true, "Remove"),
        Refunding(false, "Refunding"),
        Exiting(false, "Quiting");

        State(boolean exp, String... input) {
            inputs = Arrays.asList(input);
            explicit = exp
        }

        State nextState(String input, State current) {
            if (inputs.contains(input)) {
                return map.getOrDefault(input, current)
            }
            return current
        }

        final List<String> inputs
        final static Map<String, State> map = new HashMap<>()
        final boolean explicit

        static {
            map.put("Deposit", Waiting)
            map.put("Quit", Exiting)
            map.put("Select", Dispensing)
            map.put("Refund", Refunding)
            map.put("Remove", Ready)
            map.put("Refunding", Ready)
        }
    }

    static void main(String[] args) {
        Scanner sc = new Scanner(System.in)
        State state = State.Ready

        while (state != State.Exiting) {
            println(state.inputs)
            if (state.explicit){
                print("> ")
                state = state.nextState(sc.nextLine().trim(), state)
            } else {
                state = state.nextState(state.inputs.get(0), state)
            }
        }
    }
}
