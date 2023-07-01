public class If2 {
    private final boolean firstCondition;
    private final boolean secondCondition;

    public If2(boolean firstCondition, boolean secondCondition) {
        this.firstCondition = firstCondition;
        this.secondCondition = secondCondition;
    }

    public static If2 if2(boolean firstCondition, boolean secondCondition) {
        return new If2(firstCondition, secondCondition);
    }

    public If2 then(Runnable runnable) {
        if (firstCondition && secondCondition) {
            runnable.run();
        }
        return this;
    }

    public If2 elseNone(Runnable runnable) {
        if (!firstCondition && !secondCondition) {
            runnable.run();
        }
        return this;
    }

    public If2 elseIfFirst(Runnable runnable) {
        if (firstCondition && !secondCondition) {
            runnable.run();
        }
        return this;
    }

    public If2 elseIfSecond(Runnable runnable) {
        if (!firstCondition && secondCondition) {
            runnable.run();
        }
        return this;
    }
}
