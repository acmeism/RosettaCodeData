import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

/**
 * A class for an "Integer with a history".
 * <p>
 * Note that it is not possible to create an empty Variable (so there is no "null") with this type. This is a design
 * choice, because if "empty" variables were allowed, reading of empty variables must return a value. Null is a
 * bad idea, and Java 8's Optional<T> (which is somewhat like the the official fix for the null-bad-idea) would
 * make things more complicated than an example should be.
 */
public class IntegerWithHistory {

    /**
     * The "storage Backend" is a list of all values that have been ever assigned to this variable. The List is
     * populated front to back, so a new value is inserted at the start (position 0), and older values move toward the end.
     */
    private final List<Integer> history;

    /**
     * Creates this variable and assigns the initial value
     *
     * @param value initial value
     */
    public IntegerWithHistory(Integer value) {
        history = new LinkedList<>();
        history.add(value);
    }

    /**
     * Sets a new value, pushing the older ones back in the history
     *
     * @param value the new value to be assigned
     */
    public void set(Integer value) {
        //History is populated from the front to the back, so the freshest value is stored a position 0
        history.add(0, value);
    }

    /**
     * Gets the current value. Since history is populuated front to back, the current value is the first element
     * of the history.
     *
     * @return the current value
     */
    public Integer get() {
        return history.get(0);
    }

    /**
     * Gets the entire history all values that have been assigned to this variable.
     *
     * @return a List of all values, including the current one, ordered new to old
     */
    public List<Integer> getHistory() {
        return Collections.unmodifiableList(this.history);
    }

    /**
     * Rolls back the history one step, so the current value is removed from the history and replaced by it's predecessor.
     * This is a destructive operation! It is not possible to rollback() beyond the initial value!
     *
     * @return the value that had been the current value until history was rolled back.
     */
    public Integer rollback() {
        if (history.size() > 1) {
            return history.remove(0);
        } else {
            return history.get(0);
        }
    }
}
