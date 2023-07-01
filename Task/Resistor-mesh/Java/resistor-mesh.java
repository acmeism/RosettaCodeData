import java.util.ArrayList;
import java.util.List;

public class ResistorMesh {
    private static final int S = 10;

    private static class Node {
        double v;
        int fixed;

        Node(double v, int fixed) {
            this.v = v;
            this.fixed = fixed;
        }
    }

    private static void setBoundary(List<List<Node>> m) {
        m.get(1).get(1).v = 1.0;
        m.get(1).get(1).fixed = 1;

        m.get(6).get(7).v = -1.0;
        m.get(6).get(7).fixed = -1;
    }

    private static double calcDiff(List<List<Node>> m, List<List<Node>> d, int w, int h) {
        double total = 0.0;
        for (int i = 0; i < h; ++i) {
            for (int j = 0; j < w; ++j) {
                double v = 0.0;
                int n = 0;
                if (i > 0) {
                    v += m.get(i - 1).get(j).v;
                    n++;
                }
                if (j > 0) {
                    v += m.get(i).get(j - 1).v;
                    n++;
                }
                if (i + 1 < h) {
                    v += m.get(i + 1).get(j).v;
                    n++;
                }
                if (j + 1 < w) {
                    v += m.get(i).get(j + 1).v;
                    n++;
                }
                v = m.get(i).get(j).v - v / n;
                d.get(i).get(j).v = v;
                if (m.get(i).get(j).fixed == 0) {
                    total += v * v;
                }
            }
        }
        return total;
    }

    private static double iter(List<List<Node>> m, int w, int h) {
        List<List<Node>> d = new ArrayList<>(h);
        for (int i = 0; i < h; ++i) {
            List<Node> t = new ArrayList<>(w);
            for (int j = 0; j < w; ++j) {
                t.add(new Node(0.0, 0));
            }
            d.add(t);
        }

        double[] cur = new double[3];
        double diff = 1e10;

        while (diff > 1e-24) {
            setBoundary(m);
            diff = calcDiff(m, d, w, h);
            for (int i = 0; i < h; ++i) {
                for (int j = 0; j < w; ++j) {
                    m.get(i).get(j).v -= d.get(i).get(j).v;
                }
            }
        }

        for (int i = 0; i < h; ++i) {
            for (int j = 0; j < w; ++j) {
                int k = 0;
                if (i != 0) k++;
                if (j != 0) k++;
                if (i < h - 1) k++;
                if (j < w - 1) k++;
                cur[m.get(i).get(j).fixed + 1] += d.get(i).get(j).v * k;
            }
        }

        return (cur[2] - cur[0]) / 2.0;
    }

    public static void main(String[] args) {
        List<List<Node>> mesh = new ArrayList<>(S);
        for (int i = 0; i < S; ++i) {
            List<Node> t = new ArrayList<>(S);
            for (int j = 0; j < S; ++j) {
                t.add(new Node(0.0, 0));
            }
            mesh.add(t);
        }

        double r = 2.0 / iter(mesh, S, S);
        System.out.printf("R = %.15f", r);
    }
}
