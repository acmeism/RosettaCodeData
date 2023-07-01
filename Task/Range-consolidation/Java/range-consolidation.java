import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class RangeConsolidation {

    public static void main(String[] args) {
        displayRanges( Arrays.asList(new Range(1.1, 2.2)));
        displayRanges( Arrays.asList(new Range(6.1, 7.2), new Range(7.2, 8.3)));
        displayRanges( Arrays.asList(new Range(4, 3), new Range(2, 1)));
        displayRanges( Arrays.asList(new Range(4, 3), new Range(2, 1), new Range(-1, -2), new Range(3.9, 10)));
        displayRanges( Arrays.asList(new Range(1, 3), new Range(-6, -1), new Range(-4, -5), new Range(8, 2), new Range(-6, -6)));
        displayRanges( Arrays.asList(new Range(1, 1), new Range(1, 1)));
        displayRanges( Arrays.asList(new Range(1, 1), new Range(1, 2)));
        displayRanges( Arrays.asList(new Range(1, 2), new Range(3, 4), new Range(1.5, 3.5), new Range(1.2, 2.5)));
    }

    private static final void displayRanges(List<Range> ranges) {
        System.out.printf("ranges = %-70s, colsolidated = %s%n", ranges, Range.consolidate(ranges));
    }

    private static final class RangeSorter implements Comparator<Range> {
        @Override
        public int compare(Range o1, Range o2) {
            return (int) (o1.left - o2.left);
        }
    }

    private static class Range {
        double left;
        double right;

        public Range(double left, double right) {
            if ( left <= right ) {
                this.left = left;
                this.right = right;
            }
            else {
                this.left = right;
                this.right = left;
            }
        }

        public Range consolidate(Range range) {
            //  no overlap
            if ( this.right < range.left ) {
                return null;
            }
            //  no overlap
            if ( range.right < this.left ) {
                return null;
            }
            //  contained
            if ( this.left <= range.left && this.right >= range.right ) {
                return this;
            }
            //  contained
            if ( range.left <= this.left && range.right >= this.right ) {
                return range;
            }
            //  overlap
            if ( this.left <= range.left && this.right <= range.right ) {
                return new Range(this.left, range.right);
            }
            //  overlap
            if ( this.left >= range.left && this.right >= range.right ) {
                return new Range(range.left, this.right);
            }
            throw new RuntimeException("ERROR:  Logic invalid.");
        }

        @Override
        public String toString() {
            return "[" + left + ", " + right + "]";
        }

        private static List<Range> consolidate(List<Range> ranges) {
            List<Range> consolidated = new ArrayList<>();

            Collections.sort(ranges, new RangeSorter());

            for ( Range inRange : ranges ) {
                Range r = null;
                Range conRange = null;
                for ( Range conRangeLoop : consolidated ) {
                    r = inRange.consolidate(conRangeLoop);
                    if (r != null ) {
                        conRange = conRangeLoop;
                        break;
                    }
                }
                if ( r == null ) {
                    consolidated.add(inRange);
                }
                else {
                    consolidated.remove(conRange);
                    consolidated.add(r);
                }
            }

            Collections.sort(consolidated, new RangeSorter());

            return consolidated;
        }
    }

}
