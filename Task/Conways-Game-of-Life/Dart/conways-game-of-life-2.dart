#import('<path to sdk>/lib/unittest/unittest.dart');

main() {
  group('rules', () {
    test('should let living but lonely cell die', () {
      var rule = new Rule(State.ALIVE);
      rule.reactToNeighbours(1);
      expect(rule.cellState, State.DEAD);
    });
    test('should let proper cell live on', () {
      var rule = new Rule(State.ALIVE);
      rule.reactToNeighbours(2);
      expect(rule.cellState, State.ALIVE);
    });
    test('should let dead cell with three neighbours be reborn', () {
      var rule = new Rule(State.DEAD);
      rule.reactToNeighbours(3);
      expect(rule.cellState, State.ALIVE);
    });
    test('should let living cell with too many neighbours die', () {
      var rule = new Rule(State.ALIVE);
      rule.reactToNeighbours(4);
      expect(rule.cellState, State.DEAD);
    });
  });

  group('grid', () {
    var origin = new Point(0, 0);
    test('should have state', () {
      var grid = new Grid(1, 1);
      expect(grid.get(origin), State.DEAD);
      grid.set(origin, State.ALIVE);
      expect(grid.get(origin), State.ALIVE);
    });
    test('should have dimension', () {
      var grid = new Grid(2, 3);
      expect(grid.get(origin), State.DEAD);
      grid.set(origin, State.ALIVE);
      expect(grid.get(origin), State.ALIVE);
      expect(grid.get(new Point(1, 2)), State.DEAD);
      grid.set(new Point(1, 2), State.ALIVE);
      expect(grid.get(new Point(1, 2)), State.ALIVE);
    });
    test('should be endless', () {
      var grid = new Grid(2, 4);
      grid.set(new Point(2, 4), State.ALIVE);
      expect(grid.get(origin), State.ALIVE);
      grid.set(new Point(-1, -1), State.ALIVE);
      expect(grid.get(new Point(1, 3)), State.ALIVE);
    });
    test('should print itself', () {
      var grid = new Grid(1, 2);
      grid.set(new Point(0, 1), State.ALIVE);
      expect(grid.print(), " #\n");
    });
  });

  group('game', () {
    test('should exists', () {
     var game = new Game(null);
     expect(game, isNotNull);
    });
    test('should create a new grid when ticked', () {
      var grid = new Grid(1, 1);
      var game = new Game(grid);
      game.tick();
      expect(game.grid !== grid);
    });
    test('should have a grid with the same dimension after tick', (){
      var game = new Game(new Grid(2, 3));
      game.tick();
      expect(game.grid.xCount, 2);
      expect(game.grid.yCount, 3);
    });
    test('should apply rules to middle cell', (){
      var grid = new Grid(3, 3);
      grid.set(new Point(1, 1), State.ALIVE);
      var game = new Game(grid);
      game.tick();
      expect(game.grid.get(new Point(1, 1)), State.DEAD);

      grid.set(new Point(0, 0), State.ALIVE);
      grid.set(new Point(1, 0), State.ALIVE);
      game = new Game(grid);
      game.tick();
      expect(game.grid.get(new Point(1, 1)), State.ALIVE);
    });
    test('should apply rules to all cells', (){
      var grid = new Grid(3, 3);
      grid.set(new Point(0, 1), State.ALIVE);
      grid.set(new Point(1, 0), State.ALIVE);
      grid.set(new Point(1, 1), State.ALIVE);
      var game = new Game(grid);
      game.tick();
      expect(game.grid.get(new Point(0, 0)), State.ALIVE);
    });
  });
}
