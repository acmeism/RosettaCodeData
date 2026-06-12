import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

public class NBodySim {
    private static class Vector3D {
        double x, y, z;

        public Vector3D(double x, double y, double z) {
            this.x = x;
            this.y = y;
            this.z = z;
        }

        public Vector3D plus(Vector3D rhs) {
            return new Vector3D(x + rhs.x, y + rhs.y, z + rhs.z);
        }

        public Vector3D minus(Vector3D rhs) {
            return new Vector3D(x - rhs.x, y - rhs.y, z - rhs.z);
        }

        public Vector3D times(double s) {
            return new Vector3D(s * x, s * y, s * z);
        }

        public double mod() {
            return Math.sqrt(x * x + y * y + z * z);
        }
    }

    private static final Vector3D origin = new Vector3D(0, 0, 0);

    private static class NBody {
        private double gc;
        private int bodies;
        public final int timeSteps;
        private double[] masses;
        private Vector3D[] positions;
        private Vector3D[] velocities;
        private Vector3D[] accelerations;

        public NBody(String fileName) throws IOException {
            Path path = Paths.get(fileName);
            List<String> lines = Files.readAllLines(path);

            String[] gbt = lines.get(0).split(" ");
            gc = Double.parseDouble(gbt[0]);
            bodies = Integer.parseInt(gbt[1]);
            timeSteps = Integer.parseInt(gbt[2]);
            masses = new double[bodies];
            positions = new Vector3D[bodies];
            Arrays.fill(positions, origin);
            velocities = new Vector3D[bodies];
            Arrays.fill(velocities, origin);
            accelerations = new Vector3D[bodies];
            Arrays.fill(accelerations, origin);
            for (int i = 0; i < bodies; ++i) {
                masses[i] = Double.parseDouble(lines.get(i * 3 + 1));
                positions[i] = decompose(lines.get(i * 3 + 2));
                velocities[i] = decompose(lines.get(i * 3 + 3));
            }
            System.out.printf("Contents of %s\n", fileName);
            for (String line : lines) {
                System.out.println(line);
            }
            System.out.println();
            System.out.print("Body   :      x          y          z    |");
            System.out.println("     vx         vy         vz");
        }

        private Vector3D decompose(String line) {
            String[] xyz = line.split(" ");
            double x = Double.parseDouble(xyz[0]);
            double y = Double.parseDouble(xyz[1]);
            double z = Double.parseDouble(xyz[2]);
            return new Vector3D(x, y, z);
        }

        private void resolveCollisions() {
            for (int i = 0; i < bodies; ++i) {
                for (int j = i + 1; j < bodies; ++j) {
                    if (positions[i].x == positions[j].x
                        && positions[i].y == positions[j].y
                        && positions[i].z == positions[j].z) {
                        Vector3D temp = velocities[i];
                        velocities[i] = velocities[j];
                        velocities[j] = temp;
                    }
                }
            }
        }

        private void computeAccelerations() {
            for (int i = 0; i < bodies; ++i) {
                accelerations[i] = origin;
                for (int j = 0; j < bodies; ++j) {
                    if (i != j) {
                        double temp = gc * masses[j] / Math.pow((positions[i].minus(positions[j])).mod(), 3);
                        accelerations[i] = accelerations[i].plus(positions[j].minus(positions[i]).times(temp));
                    }
                }
            }
        }

        private void computeVelocities() {
            for (int i = 0; i < bodies; ++i) {
                velocities[i] = velocities[i].plus(accelerations[i]);
            }
        }

        private void computePositions() {
            for (int i = 0; i < bodies; ++i) {
                positions[i] = positions[i].plus(velocities[i]).plus(accelerations[i].times(0.5));
            }
        }

        public void simulate() {
            computeAccelerations();
            computePositions();
            computeVelocities();
            resolveCollisions();
        }

        public void printResults() {
            String fmt = "Body %d : % 8.6f  % 8.6f  % 8.6f | % 8.6f  % 8.6f  % 8.6f\n";
            for (int i = 0; i < bodies; ++i) {
                System.out.printf(
                    fmt,
                    i + 1,
                    positions[i].x, positions[i].y, positions[i].z,
                    velocities[i].x, velocities[i].y, velocities[i].z
                );
            }
        }
    }

    public static void main(String[] args) throws IOException {
        String filename = "nbody.txt";
        NBody nb = new NBody(filename);
        for (int i = 0; i < nb.timeSteps; ++i) {
            System.out.printf("\nCycle %s\n", i + 1);
            nb.simulate();
            nb.printResults();
        }
    }
}
