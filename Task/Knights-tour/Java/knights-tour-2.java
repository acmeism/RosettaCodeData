package com.knight.tour;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class KT {

	private int baseSize = 12; // virtual board size including unreachable out-of-board nodes. i.e. base 12 = 8X8 board	
	int actualBoardSize = baseSize - 4;
	private static final int[][] moves = { { 1, -2 }, { 2, -1 }, { 2, 1 }, { 1, 2 }, { -1, 2 }, { -2, 1 }, { -2, -1 },
			{ -1, -2 } };
	private static int[][] grid;
	private static int totalNodes;
	private ArrayList<int[]> travelledNodes = new ArrayList<>();
	public KT(int baseNumber) {
		this.baseSize = baseNumber;
		this.actualBoardSize = baseSize - 4;
	}

	public static void main(String[] args) {
		new KT(12).tour(); // find a solution for 8X8 board
//		new KT(24).tour(); // then for 20X20 board
//		new KT(104).tour(); // then for 100X100 board
	}

	private void tour() {
		totalNodes = actualBoardSize * actualBoardSize;
		travelledNodes.clear();
		grid = new int[baseSize][baseSize];
		for (int r = 0; r < baseSize; r++)
			for (int c = 0; c < baseSize; c++) {
				if (r < 2 || r > baseSize - 3 || c < 2 || c > baseSize - 3) {
					grid[r][c] = -1; // mark as out-of-board nodes
				} else {
					grid[r][c] = 0; // nodes within chess board.
				}
			}
		// start from a random node
		int startRow = 2 + (int) (Math.random() * actualBoardSize);
		int startCol = 2 + (int) (Math.random() * actualBoardSize);
		int[] start = { startRow, startCol, 0, 1 };
		grid[startRow][startCol] = 1; // mark the first traveled node
		travelledNodes.add(start); // add to partial solution chain, which will only have one node.

		// Start traveling forward
		autoKnightTour(start, 2);
	}

	// non-backtracking touring methods. Re-chain the partial solution when all neighbors are traveled to avoid back-tracking.
	private void autoKnightTour(int[] start, int nextCount) {
		List<int[]> nbrs = neighbors(start[0], start[1]);
		if (nbrs.size() > 0) {
			Collections.sort(nbrs, new Comparator<int[]>() {
				public int compare(int[] a, int[] b) {
					return a[2] - b[2];
				}
			}); // sort the list
			int[] next = nbrs.get(0); // the one with the less available neighbors - Warnsdorff's algorithm
			next[3] = nextCount;
			travelledNodes.add(next);
			grid[next[0]][next[1]] = nextCount;
			if (travelledNodes.size() == totalNodes) {
				System.out.println("Found a path for " + actualBoardSize + " X " + actualBoardSize + " chess board.");
				StringBuilder sb = new StringBuilder();
				sb.append(System.lineSeparator());
				for (int idx = 0; idx < travelledNodes.size(); idx++) {
					int[] item = travelledNodes.get(idx);
					sb.append("->(" + (item[0] - 2) + "," + (item[1] - 2) + ")");
					if ((idx + 1) % 15 == 0) {
						sb.append(System.lineSeparator());
					}
				}
				System.out.println(sb.toString() + "\n");
			} else { // continuing the travel
				autoKnightTour(next, ++nextCount);
			}
		} else { // no travelable neighbors next - need to rechain the partial chain
			int[] last = travelledNodes.get(travelledNodes.size() - 1);
			travelledNodes = reChain(travelledNodes);
			if (travelledNodes.get(travelledNodes.size() - 1).equals(last)) {
				travelledNodes = reChain(travelledNodes);
				if (travelledNodes.get(travelledNodes.size() - 1).equals(last)) {
					System.out.println("Re-chained twice but no travllable node found. Quiting...");
				} else {
					int[] end = travelledNodes.get(travelledNodes.size() - 1);
					autoKnightTour(end, nextCount);
				}
			} else {
				int[] end = travelledNodes.get(travelledNodes.size() - 1);
				autoKnightTour(end, nextCount);
			}
		}
	}

	private ArrayList<int[]> reChain(ArrayList<int[]> alreadyTraveled) {
		int[] last = alreadyTraveled.get(alreadyTraveled.size() - 1);
		List<int[]> candidates = neighborsInChain(last[0], last[1]);
		int cutIndex;
		int[] randomPicked = candidates.get((int) Math.random() * candidates.size());
		cutIndex = grid[randomPicked[0]][randomPicked[1]] - 1;
		ArrayList<int[]> result = new ArrayList<int[]>(); //create empty list to copy already traveled nodes to
		for (int k = 0; k <= cutIndex; k++) {
			result.add(result.size(), alreadyTraveled.get(k));
		}
		for (int j = alreadyTraveled.size() - 1; j > cutIndex; j--) {
			alreadyTraveled.get(j)[3] = result.size();
			result.add(result.size(), alreadyTraveled.get(j));
		}
		return result; // re-chained partial solution with different end node
	}

	private List<int[]> neighborsInChain(int r, int c) {
		List<int[]> nbrs = new ArrayList<>();
		for (int[] m : moves) {
			int x = m[0];
			int y = m[1];
			if (grid[r + y][c + x] > 0 && grid[r + y][c + x] != grid[r][c] - 1) {
				int num = countNeighbors(r + y, c + x);
				nbrs.add(new int[] { r + y, c + x, num, 0 });
			}
		}
		return nbrs;
	}

	private static List<int[]> neighbors(int r, int c) {
		List<int[]> nbrs = new ArrayList<>();
		for (int[] m : moves) {
			int x = m[0];
			int y = m[1];
			if (grid[r + y][c + x] == 0) {
				int num = countNeighbors(r + y, c + x);
				nbrs.add(new int[] { r + y, c + x, num, 0 }); // not-traveled neighbors and number of their neighbors
			}
		}
		return nbrs;

	}

	private List<int[]> extendableNeighbors(List<int[]> neighbors) {
		List<int[]> nbrs = new ArrayList<>();
		for (int[] node : neighbors) {
			if (node[2] > 0)
				nbrs.add(node);
		}
		return nbrs;
	}

	private static int countNeighbors(int r, int c) {
		int num = 0;
		for (int[] m : moves) {
			if (grid[r + m[1]][c + m[0]] == 0) {
				num++;
			}
		}
		return num;
	}
}
