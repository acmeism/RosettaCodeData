using System;
using System.IO;

namespace NBodyProblem {
    class Vector3D {
        public Vector3D(double x, double y, double z) {
            X = x;
            Y = y;
            Z = z;
        }

        public double X { get; }
        public double Y { get; }
        public double Z { get; }

        public double Mod() {
            return Math.Sqrt(X * X + Y * Y + Z * Z);
        }

        public static Vector3D operator +(Vector3D lhs, Vector3D rhs) {
            return new Vector3D(lhs.X + rhs.X, lhs.Y + rhs.Y, lhs.Z + rhs.Z);
        }

        public static Vector3D operator -(Vector3D lhs, Vector3D rhs) {
            return new Vector3D(lhs.X - rhs.X, lhs.Y - rhs.Y, lhs.Z - rhs.Z);
        }

        public static Vector3D operator *(Vector3D lhs, double rhs) {
            return new Vector3D(lhs.X * rhs, lhs.Y * rhs, lhs.Z * rhs);
        }
    }

    class NBody {
        private readonly double gc;
        private readonly int bodies;
        private readonly int timeSteps;
        private readonly double[] masses;
        private readonly Vector3D[] positions;
        private readonly Vector3D[] velocities;
        private readonly Vector3D[] accelerations;

        public NBody(string fileName) {
            string[] lines = File.ReadAllLines(fileName);

            string[] gbt = lines[0].Split();
            gc = double.Parse(gbt[0]);
            bodies = int.Parse(gbt[1]);
            timeSteps = int.Parse(gbt[2]);

            masses = new double[bodies];
            positions = new Vector3D[bodies];
            velocities = new Vector3D[bodies];
            accelerations = new Vector3D[bodies];
            for (int i = 0; i < bodies; ++i) {
                masses[i] = double.Parse(lines[i * 3 + 1]);
                positions[i] = Decompose(lines[i * 3 + 2]);
                velocities[i] = Decompose(lines[i * 3 + 3]);
            }

            Console.WriteLine("Contents of {0}", fileName);
            foreach (string line in lines) {
                Console.WriteLine(line);
            }
            Console.WriteLine();
            Console.Write("Body   :      x          y          z    |");
            Console.WriteLine("     vx         vy         vz");
        }

        public int GetTimeSteps() {
            return timeSteps;
        }

        private Vector3D Decompose(string line) {
            string[] xyz = line.Split();
            double x = double.Parse(xyz[0]);
            double y = double.Parse(xyz[1]);
            double z = double.Parse(xyz[2]);
            return new Vector3D(x, y, z);
        }

        private void ComputeAccelerations() {
            for (int i = 0; i < bodies; ++i) {
                accelerations[i] = new Vector3D(0, 0, 0);
                for (int j = 0; j < bodies; ++j) {
                    if (i != j) {
                        double temp = gc * masses[j] / Math.Pow((positions[i] - positions[j]).Mod(), 3);
                        accelerations[i] = accelerations[i] + (positions[j] - positions[i]) * temp;
                    }
                }
            }
        }

        private void ComputeVelocities() {
            for (int i = 0; i < bodies; ++i) {
                velocities[i] = velocities[i] + accelerations[i];
            }
        }

        private void ComputePositions() {
            for (int i = 0; i < bodies; ++i) {
                positions[i] = positions[i] + velocities[i] + accelerations[i] * 0.5;
            }
        }

        private void ResolveCollisions() {
            for (int i = 0; i < bodies; ++i) {
                for (int j = i + 1; j < bodies; ++j) {
                    if (positions[i].X == positions[j].X
                     && positions[i].Y == positions[j].Y
                     && positions[i].Z == positions[j].Z) {
                        Vector3D temp = velocities[i];
                        velocities[i] = velocities[j];
                        velocities[j] = temp;
                    }
                }
            }
        }

        public void Simulate() {
            ComputeAccelerations();
            ComputePositions();
            ComputeVelocities();
            ResolveCollisions();
        }

        public void PrintResults() {
            for (int i = 0; i < bodies; ++i) {
                Console.WriteLine(
                    "Body {0} : {1,9:F6}  {2,9:F6}  {3,9:F6} | {4,9:F6}  {5,9:F6}  {6,9:F6}",
                    i + 1,
                    positions[i].X, positions[i].Y, positions[i].Z,
                    velocities[i].X, velocities[i].Y, velocities[i].Z
                );
            }
        }
    }

    class Program {
        static void Main(string[] args) {
            NBody nb = new NBody("nbody.txt");

            for (int i = 0; i < nb.GetTimeSteps(); ++i) {
                Console.WriteLine();
                Console.WriteLine("Cycle {0}", i + 1);
                nb.Simulate();
                nb.PrintResults();
            }
        }
    }
}
