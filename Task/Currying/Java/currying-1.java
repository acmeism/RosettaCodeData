    public class Currier<ARG1, ARG2, RET> {
        public interface CurriableFunctor<ARG1, ARG2, RET> {
            RET evaluate(ARG1 arg1, ARG2 arg2);
        }

        public interface CurriedFunctor<ARG2, RET> {
            RET evaluate(ARG2 arg);
        }

        final CurriableFunctor<ARG1, ARG2, RET> functor;

        public Currier(CurriableFunctor<ARG1, ARG2, RET> fn) { functor = fn; }

        public CurriedFunctor<ARG2, RET> curry(final ARG1 arg1) {
            return new CurriedFunctor<ARG2, RET>() {
                public RET evaluate(ARG2 arg2) {
                    return functor.evaluate(arg1, arg2);
                }
            };
        }

        public static void main(String[] args) {
            Currier.CurriableFunctor<Integer, Integer, Integer> add
                = new Currier.CurriableFunctor<Integer, Integer, Integer>() {
                    public Integer evaluate(Integer arg1, Integer arg2) {
                        return new Integer(arg1.intValue() + arg2.intValue());
                    }
            };

            Currier<Integer, Integer, Integer> currier
                = new Currier<Integer, Integer, Integer>(add);

            Currier.CurriedFunctor<Integer, Integer> add5
                = currier.curry(new Integer(5));

            System.out.println(add5.evaluate(new Integer(2)));
        }
    }
