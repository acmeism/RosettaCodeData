import 'dart:collection';
import 'dart:math';

// In Dart, classes should be defined at the top level, not nested
class Node implements Comparable<Node> {
  Node? parent;
  int x, y;
  double g;
  double h;

  Node(this.parent, this.x, this.y, this.g, this.h);

  // Compare by f value (g + h)
  @override
  int compareTo(Node other) {
    return ((this.g + this.h) - (other.g + other.h)).toInt();
  }
}

class MazeCoord {
  MazeCoord? father;
  int _r = 0;
  int _c = 0;
  int costToGoal = 0;
  int pathCost = 0;
  int aStartCost = 0;

  int getR() => _r;
  int getC() => _c;

  MazeCoord expandDirection() => MazeCoord();

  int calculateCost(MazeCoord goal) {
    int rState = getR();
    int rGoal = goal.getR();
    int diffR = rState - rGoal;
    int diffC = getC() - goal.getC();
    if (diffR * diffC > 0) {
      // same sign
      return diffR.abs() + diffC.abs();
    } else {
      return max(diffR.abs(), diffC.abs());
    }
  }

  MazeCoord getFather() {
    return father!;
  }

  void setFather(MazeCoord node) {
    this.father = node;
  }

  int getAStartCost() {
    return aStartCost;
  }

  void setAStartCost(int aStartCost) {
    this.aStartCost = aStartCost;
  }

  int getCostToGoal() {
    return costToGoal;
  }

  void setCostToGoal(int costToGoal) {
    this.costToGoal = costToGoal;
  }

  int getPathCost() {
    return pathCost;
  }

  void setPathCost(int pathCost) {
    this.pathCost = pathCost;
  }
}

class AStar {
  final List<Node> open;
  final List<Node> closed;
  final List<Node> path;
  final List<List<int>> maze;
  late Node now;
  final int xstart;
  final int ystart;
  late int xend, yend;
  final bool diag;

  // Additional members to support the other methods
  late MazeCoord start;
  late MazeCoord goal;
  Queue<MazeCoord> frontier = Queue<MazeCoord>();
  List<MazeCoord> explored = [];

  AStar(this.maze, this.xstart, this.ystart, this.diag)
      : open = [],
        closed = [],
        path = [] {
    this.now = Node(null, xstart, ystart, 0, 0);
    this.start = MazeCoord();
    this.goal = MazeCoord();
  }

  /*
  ** Finds path to xend/yend or returns null
  **
  ** @param (int) xend coordinates of the target position
  ** @param (int) yend
  ** @return (List<Node> | null) the path
  */
  List<Node>? findPathTo(int xend, int yend) {
    this.xend = xend;
    this.yend = yend;
    this.closed.add(this.now);
    addNeighborsToOpenList();
    while (this.now.x != this.xend || this.now.y != this.yend) {
      if (this.open.isEmpty) {
        // Nothing to examine
        return null;
      }
      this.now = this.open[0]; // get first node (lowest f score)
      this.open.removeAt(0); // remove it
      this.closed.add(this.now); // and add to the closed
      addNeighborsToOpenList();
    }
    this.path.insert(0, this.now);
    while (this.now.x != this.xstart || this.now.y != this.ystart) {
      this.now = this.now.parent!;
      this.path.insert(0, this.now);
    }
    return this.path;
  }

  /*
  ** This function is the step of expanding nodes
  **
  */
  void expandAStar(List<List<int>> maze, int xstart, int ystart, bool diag) {
    Queue<MazeCoord> exploreNodes = Queue<MazeCoord>();
    MazeCoord stateNode = MazeCoord();

    if (maze[stateNode.getR()][stateNode.getC()] == 2) {
      if (isNodeILegal(stateNode, stateNode.expandDirection())) {
        exploreNodes.add(stateNode.expandDirection());
      }
    }
  }

  bool isNodeILegal(MazeCoord stateNode, MazeCoord direction) {
    // This is a placeholder implementation
    return true;
  }

  /*
  ** Calculate distance for goal three methods shown.
  **
  */
  void aStarSearch() {
    this.start.setCostToGoal(this.start.calculateCost(this.goal));
    this.start.setPathCost(0);
    this.start.setAStartCost(this.start.getPathCost() + this.start.getCostToGoal());
    MazeCoord initialNode = this.start;
    MazeCoord stateNode = initialNode;
    frontier.add(initialNode);
    //explored<Queue> is empty
    while (true) {
      if (frontier.isEmpty) {
        print("fail");
        print(explored.length);
        // In Dart, we don't use System.exit, instead we can return or throw
        return;
      }
      // Rest of the algorithm would go here
      break; // Added to prevent infinite loop
    }
  }

  /*
  ** Third method for distance calculation.
  */
  double distance(int dx, int dy) {
    if (this.diag) {
      // if diagonal movement is allowed
      return sqrt(pow(this.now.x + dx - this.xend, 2) +
                  pow(this.now.y + dy - this.yend, 2)); // return hypotenuse
    } else {
      return ((this.now.x + dx - this.xend).abs() +
             (this.now.y + dy - this.yend).abs()).toDouble(); // else return "Manhattan distance"
    }
  }

  bool findNeighborInList(List<Node> list, Node node) {
    return list.any((n) => n.x == node.x && n.y == node.y);
  }

  void addNeighborsToOpenList() {
    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        if (!this.diag && x != 0 && y != 0) {
          continue; // skip if diagonal movement is not allowed
        }

        Node node = Node(this.now, this.now.x + x, this.now.y + y,
                         this.now.g, this.distance(x, y));

        if ((x != 0 || y != 0) && // not this.now
            this.now.x + x >= 0 &&
            this.now.x + x < this.maze[0].length && // check maze boundaries
            this.now.y + y >= 0 &&
            this.now.y + y < this.maze.length &&
            this.maze[this.now.y + y][this.now.x + x] != -1 && // check if square is walkable
            !findNeighborInList(this.open, node) &&
            !findNeighborInList(this.closed, node)) { // if not already done

          node.g = node.parent!.g + 1.0; // Horizontal/vertical cost = 1.0
          node.g += maze[this.now.y + y][this.now.x + x]; // add movement cost for this square

          // diagonal cost = sqrt(hor_cost² + vert_cost²)
          // in this example the cost would be 12.2 instead of 11
          /*
          if (diag && x != 0 && y != 0) {
              node.g += 0.4;  // Diagonal movement cost = 1.4
          }
          */
          this.open.add(node);
        }
      }
    }
    this.open.sort();
  }
}

void main() {
  // -1 = blocked
  // 0+ = additional movement cost
  List<List<int>> maze = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 100, 100, 100, 0, 0],
    [0, 0, 0, 0, 0, 100, 0, 0],
    [0, 0, 100, 0, 0, 100, 0, 0],
    [0, 0, 100, 0, 0, 100, 0, 0],
    [0, 0, 100, 100, 100, 100, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
  ];

  AStar as = AStar(maze, 0, 0, true);
  List<Node>? path = as.findPathTo(7, 7);

  if (path != null) {
    for (Node n in path) {
      print("[${n.x}, ${n.y}] ");
      maze[n.y][n.x] = -1;
    }
    print("\nTotal cost: ${path[path.length - 1].g.toStringAsFixed(2)}");

    for (List<int> mazeRow in maze) {
      String rowStr = "";
      for (int mazeEntry in mazeRow) {
        switch (mazeEntry) {
          case 0:
            rowStr += "_";
            break;
          case -1:
            rowStr += "*";
            break;
          default:
            rowStr += "#";
        }
      }
      print(rowStr);
    }
  }
}
