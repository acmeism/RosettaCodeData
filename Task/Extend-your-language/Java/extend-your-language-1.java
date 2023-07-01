public class If2 {

    public static void if2(boolean firstCondition, boolean secondCondition,
                           Runnable bothTrue, Runnable firstTrue, Runnable secondTrue, Runnable noneTrue) {
        if (firstCondition)
            if (secondCondition)
                bothTrue.run();
            else firstTrue.run();
        else if (secondCondition)
            secondTrue.run();
        else noneTrue.run();
    }
}
