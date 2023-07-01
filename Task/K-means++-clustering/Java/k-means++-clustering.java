import java.util.Random;

public class KMeansWithKpp{
		// Variables Needed
		public Point[] points;
		public Point[] centroids;
		Random rand;
		public int n;
		public int k;

		// hide default constructor
		private KMeansWithKpp(){
		}

		KMeansWithKpp(Point[] p, int clusters){
				points = p;
				n = p.length;
				k = Math.max(1, clusters);
				centroids = new Point[k];
				rand = new Random();
		}


		private static double distance(Point a, Point b){
				return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y);
		}

		private static int nearest(Point pt, Point[] others, int len){
				double minD = Double.MAX_VALUE;
				int index = pt.group;
				len = Math.min(others.length, len);
				double dist;
				for (int i = 0; i < len; i++) {
						if (minD > (dist = distance(pt, others[i]))) {
								minD = dist;
								index = i;
						}
				}
				return index;
		}

		private static double nearestDistance(Point pt, Point[] others, int len){
				double minD = Double.MAX_VALUE;
				len = Math.min(others.length, len);
				double dist;
				for (int i = 0; i < len; i++) {
						if (minD > (dist = distance(pt, others[i]))) {
								minD = dist;
						}
				}
				return minD;
		}

		private void kpp(){
				centroids[0] = points[rand.nextInt(n)];
				double[] dist = new double[n];
				double sum = 0;
				for (int i = 1; i < k; i++) {
						for (int j = 0; j < n; j++) {
								dist[j] = nearestDistance(points[j], centroids, i);
								sum += dist[j];
						}
						sum = (sum * rand.nextInt(Integer.MAX_VALUE)) / Integer.MAX_VALUE;
						for (int j = 0; j < n; j++) {
								if ((sum -= dist[j]) > 0)
										continue;
								centroids[i].x = points[j].x;
								centroids[i].y = points[j].y;
						}
				}
				for (int i = 0; i < n; i++) {
						points[i].group = nearest(points[i], centroids, k);
				}
		}

		public void kMeans(int maxTimes){
				if (k == 1 || n <= 0) {
						return;
				}
				if(k >= n){
						for(int i =0; i < n; i++){
								points[i].group = i;
						}
						return;
				}
				maxTimes = Math.max(1, maxTimes);
				int changed;
				int bestPercent = n/1000;
				int minIndex;
				kpp();
				do {
						for (Point c : centroids) {
								c.x = 0.0;
								c.y = 0.0;
								c.group = 0;
						}
						for (Point pt : points) {
								if(pt.group < 0 || pt.group > centroids.length){
										pt.group = rand.nextInt(centroids.length);
								}
								centroids[pt.group].x += pt.x;
								centroids[pt.group].y = pt.y;
								centroids[pt.group].group++;
						}
						for (Point c : centroids) {
								c.x /= c.group;
								c.y /= c.group;
						}
						changed = 0;
						for (Point pt : points) {
								minIndex = nearest(pt, centroids, k);
								if (k != pt.group) {
										changed++;
										pt.group = minIndex;
								}
						}
						maxTimes--;
				} while (changed > bestPercent && maxTimes > 0);
		}
}


// A class for point(x,y) in plane

class Point{
		public double x;
		public double y;
		public int group;

		Point(){
				x = y = 0.0;
				group = 0;
		}

		/*
			Generates a random points on 2D Plane within given X-axis and Y-axis
		 */
		public Point[] getRandomPlaneData(double minX, double maxX, double minY, double maxY, int size){
				if (size <= 0)
						return null;
				double xdiff, ydiff;
				xdiff = maxX - minX;
				ydiff = maxY - minY;
				if (minX > maxX) {
						xdiff = minX - maxX;
						minX = maxX;
				}
				if (maxY < minY) {
						ydiff = minY - maxY;
						minY = maxY;
				}
				Point[] data = new Point[size];
				Random rand = new Random();
				for (int i = 0; i < size; i++) {
						data[i].x = minX + (xdiff * rand.nextInt(Integer.MAX_VALUE)) / Integer.MAX_VALUE;
						data[i].y = minY + (ydiff * rand.nextInt(Integer.MAX_VALUE)) / Integer.MAX_VALUE;
				}
				return data;
		}

		/*
	             Generate Random Polar Coordinates within given radius
		 */
		public Point[] getRandomPolarData(double radius, int size){
				if (size <= 0) {
						return null;
				}
				Point[] data = new Point[size];
				double radi, arg;
				Random rand = new Random();
				for (int i = 0; i < size; i++) {
						radi = (radius * rand.nextInt(Integer.MAX_VALUE)) / Integer.MAX_VALUE;
						arg = (2 * Math.PI * rand.nextInt(Integer.MAX_VALUE)) / Integer.MAX_VALUE;
						data[i].x = radi * Math.cos(arg);
						data[i].y = radi * Math.sin(arg);
				}
				return data;
		}
		
}
