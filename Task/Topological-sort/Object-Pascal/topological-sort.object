program topologicalsortrosetta;

{*
Topological sorter to parse e.g. dependencies.
Written for FreePascal 2.4.x/2.5.1. Probably works in Delphi, but you'd have to
change some units.
*}
{$IFDEF FPC}
// FreePascal-specific setup
{$mode objfpc}
uses {$IFDEF UNIX}
  cwstring, {* widestring support for unix *} {$IFDEF UseCThreads}
  cthreads, {$ENDIF UseCThreads} {$ENDIF UNIX}
  Classes,
  SysUtils;
{$ENDIF}

type
  RNodeIndex = record
    NodeName: WideString; //Name of the node
    //Index: integer; //Index number used in DepGraph. For now, we can distill the index from the array index. If we want to use a TList or similar, we'd need an index property
    Order: integer;  //Order when sorted
  end;

  RDepGraph = record
    Node: integer;  //Refers to Index in NodeIndex
    DependsOn: integer; //The Node depends on this other Node.
  end;

  { TTopologicalSort }

  TTopologicalSort = class(TObject)
  private
    Nodes: array of RNodeIndex;
    DependencyGraph: array of RDepGraph;
    FCanBeSorted: boolean;
    function SearchNode(NodeName: WideString): integer;
    function SearchIndex(NodeID: integer): WideString;
    function DepFromNodeID(NodeID: integer): integer;
    function DepFromDepID(DepID: integer): integer;
    function DepFromNodeIDDepID(NodeID, DepID: integer): integer;
    procedure DelDependency(const Index: integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SortOrder(var Output: TStringList);
    procedure AddNode(NodeName: WideString);
    procedure AddDependency(NodeName, DependsOn: WideString);
    procedure AddNodeDependencies(NodeAndDependencies: TStringList);
    //Each string has node, and the nodes it depends on. This allows insertion of an entire dependency graph at once
    //procedure DelNode(NodeName: Widestring);
    procedure DelDependency(NodeName, DependsOn: WideString);

    property CanBeSorted: boolean read FCanBeSorted;

  end;

const
  INVALID = -1;
  // index not found for index search functions, no sort order defined, or record invalid/deleted

  function TTopologicalSort.SearchNode(NodeName: WideString): integer;
  var
    Counter: integer;
  begin
    // Return -1 if node not found. If node found, return index in array
    Result := INVALID;
    for Counter := 0 to High(Nodes) do
    begin
      if Nodes[Counter].NodeName = NodeName then
      begin
        Result := Counter;
        break;
      end;
    end;
  end;

  function TTopologicalSort.SearchIndex(NodeID: integer): WideString;
    //Look up name for the index
  begin
    if (NodeID > 0) and (NodeID <= High(Nodes)) then
    begin
      Result := Nodes[NodeID].NodeName;
    end
    else
    begin
      Result := 'ERROR'; //something's fishy, this shouldn't happen
    end;
  end;

  function TTopologicalSort.DepFromNodeID(NodeID: integer): integer;
    // Look for Node index number in the dependency graph
    // and return the first node found. If nothing found, return -1
  var
    Counter: integer;
  begin
    Result := INVALID;
    for Counter := 0 to High(DependencyGraph) do
    begin
      if DependencyGraph[Counter].Node = NodeID then
      begin
        Result := Counter;
        break;
      end;
    end;
  end;

  function TTopologicalSort.DepFromDepID(DepID: integer): integer;
    // Look for dependency index number in the dependency graph
    // and return the index for the first one found. If nothing found, return -1
  var
    Counter: integer;
  begin
    Result := INVALID;
    for Counter := 0 to High(DependencyGraph) do
    begin
      if DependencyGraph[Counter].DependsOn = DepID then
      begin
        Result := Counter;
        break;
      end;
    end;
  end;

  function TTopologicalSort.DepFromNodeIDDepID(NodeID, DepID: integer): integer;
    // Shows index for the dependency from NodeID on DepID, or INVALID if not found
  var
    Counter: integer;
  begin
    Result := INVALID;
    for Counter := 0 to High(DependencyGraph) do
    begin
      if DependencyGraph[Counter].Node = NodeID then
        if DependencyGraph[Counter].DependsOn = DepID then
        begin
          Result := Counter;
          break;
        end;
    end;
  end;

  procedure TTopologicalSort.DelDependency(const Index: integer);
  // Removes dependency from array.
  // Is fastest when the dependency is near the top of the array
  // as we're copying the remaining elements.
  var
    Counter: integer;
    OriginalLength: integer;
  begin
    OriginalLength := Length(DependencyGraph);
    if Index = OriginalLength - 1 then
    begin
      SetLength(DependencyGraph, OriginalLength - 1);
    end;
    if Index < OriginalLength - 1 then
    begin
      for Counter := Index to OriginalLength - 2 do
      begin
        DependencyGraph[Counter] := DependencyGraph[Counter + 1];
      end;
      SetLength(DependencyGraph, OriginalLength - 1);
    end;
    if Index > OriginalLength - 1 then
    begin
      // This could happen when deleting on an empty array:
      raise Exception.Create('Tried to delete index ' + IntToStr(Index) +
        ' while the maximum index was ' + IntToStr(OriginalLength - 1));
    end;
  end;

  constructor TTopologicalSort.Create;
  begin
    inherited Create;
  end;

  destructor TTopologicalSort.Destroy;
  begin
    // Clear up data just to make sure:
    Finalize(DependencyGraph);
    Finalize(Nodes);
    inherited;
  end;

  procedure TTopologicalSort.SortOrder(var Output: TStringList);
  var
    Counter: integer;
    NodeCounter: integer;
    OutputSortOrder: integer;
    DidSomething: boolean; //used to detect cycles (circular references)
    Node: integer;
  begin
    OutputSortOrder := 0;
    DidSomething := True; // prime the loop below
    FCanBeSorted := True; //hope for the best.
    while (DidSomething = True) do
    begin
      // 1. Find all nodes (now) without dependencies, output them first and remove the dependencies:
      // 1.1 Nodes that are not present in the dependency graph at all:
      for Counter := 0 to High(Nodes) do
      begin
        if DepFromNodeID(Counter) = INVALID then
        begin
          if DepFromDepID(Counter) = INVALID then
          begin
            // Node doesn't occur in either side of the dependency graph, so it has sort order 0:
            DidSomething := True;
            if (Nodes[Counter].Order = INVALID) or
              (Nodes[Counter].Order > OutputSortOrder) then
            begin
              // Enter sort order if the node doesn't have a lower valid order already.
              Nodes[Counter].Order := OutputSortOrder;
            end;
          end; //Invalid Dep
        end; //Invalid Node
      end; //Count
      // Done with the first batch, so we can increase the sort order:
      OutputSortOrder := OutputSortOrder + 1;
      // 1.2 Nodes that are only present on the right hand side of the dep graph:
      DidSomething := False;
      // reverse order so we can delete dependencies without passing upper array
      for Counter := High(DependencyGraph) downto 0 do
      begin
        Node := DependencyGraph[Counter].DependsOn; //the depended node
        if (DepFromNodeID(Node) = INVALID) then
        begin
          DidSomething := True;
          //Delete dependency so we don't hit it again:
          DelDependency(Counter);
          if (Nodes[Node].Order = INVALID) or (Nodes[Node].Order > OutputSortOrder) then
          begin
            // Enter sort order if the node doesn't have a lower valid order already.
            Nodes[Node].Order := OutputSortOrder;
          end;
        end;
        OutputSortOrder := OutputSortOrder + 1; //next iteration
      end;
      // 2. Go back to 1 until we can't do more work, and do some bookkeeping:
      OutputSortOrder := OutputSortOrder + 1;
    end; //outer loop for 1 to 2
    OutputSortOrder := OutputSortOrder - 1; //fix unused last loop.

    // 2. If we have dependencies left, we have a cycle; exit.
    if (High(DependencyGraph) > 0) then
    begin
      FCanBeSorted := False; //indicate we have a cycle
      Output.Add('Cycle (circular dependency) detected, cannot sort further. Dependencies left:');
      for Counter := 0 to High(DependencyGraph) do
      begin
        Output.Add(SearchIndex(DependencyGraph[Counter].Node) +
          ' depends on: ' + SearchIndex(DependencyGraph[Counter].DependsOn));
      end;
    end
    else
    begin
      // No cycle:
      // Now parse results, if we have them
      for Counter := 0 to OutputSortOrder do
      begin
        for NodeCounter := 0 to High(Nodes) do
        begin
          if Nodes[NodeCounter].Order = Counter then
          begin
            Output.Add(Nodes[NodeCounter].NodeName);
          end;
        end; //output each result
      end; //order iteration
    end; //cycle detection
  end;

  procedure TTopologicalSort.AddNode(NodeName: WideString);
  var
    NodesNewLength: integer;
  begin
    // Adds node; make sure we don't add duplicate entries
    if SearchNode(NodeName) = INVALID then
    begin
      NodesNewLength := Length(Nodes) + 1;
      SetLength(Nodes, NodesNewLength);
      Nodes[NodesNewLength - 1].NodeName := NodeName; //Arrays are 0 based
      //Nodes[NodesNewLength -1].Index :=  //If we change the object to a tlist or something, we already have an index property
      Nodes[NodesNewLength - 1].Order := INVALID; //default value
    end;
  end;

  procedure TTopologicalSort.AddDependency(NodeName, DependsOn: WideString);
  begin
    // Make sure both nodes in the dependency exist as a node
    if SearchNode(NodeName) = INVALID then
    begin
      Self.AddNode(NodeName);
    end;
    if SearchNode(DependsOn) = INVALID then
    begin
      Self.AddNode(DependsOn);
    end;
    // Add the dependency, only if we don't depend on ourselves:
    if NodeName <> DependsOn then
    begin
      SetLength(DependencyGraph, Length(DependencyGraph) + 1);
      DependencyGraph[High(DependencyGraph)].Node := SearchNode(NodeName);
      DependencyGraph[High(DependencyGraph)].DependsOn := SearchNode(DependsOn);
    end;
  end;

  procedure TTopologicalSort.AddNodeDependencies(NodeAndDependencies: TStringList);
  // Takes a stringlist containing a list of strings. Each string contains node names
  // separated by spaces. The first node depends on the others. It is permissible to have
  // only one node name, which doesn't depend on anything.
  // This procedure will add the dependencies and the nodes in one go.
  var
    Deplist: TStringList;
    StringCounter: integer;
    NodeCounter: integer;
  begin
    if Assigned(NodeAndDependencies) then
    begin
      DepList := TStringList.Create;
      try
        for StringCounter := 0 to NodeAndDependencies.Count - 1 do
        begin
          // For each string in the argument: split into names, and process:
          DepList.Delimiter := ' '; //use space to separate the entries
          DepList.StrictDelimiter := False; //allows us to ignore double spaces in input.
          DepList.DelimitedText := NodeAndDependencies[StringCounter];
          for NodeCounter := 0 to DepList.Count - 1 do
          begin
            if NodeCounter = 0 then
            begin
              // Add the first node, which might be the only one.
              Self.AddNode(Deplist[0]);
            end;

            if NodeCounter > 0 then
            begin
              // Only add dependency from the second item onwards
              // The AddDependency code will automatically add Deplist[0] to the Nodes, if required
              Self.AddDependency(DepList[0], DepList[NodeCounter]);
            end;
          end;
        end;
      finally
        DepList.Free;
      end;
    end;
  end;

  procedure TTopologicalSort.DelDependency(NodeName, DependsOn: WideString);
  // Delete the record.
  var
    NodeID: integer;
    DependsID: integer;
    Dependency: integer;
  begin
    NodeID := Self.SearchNode(NodeName);
    DependsID := Self.SearchNode(DependsOn);
    if (NodeID <> INVALID) and (DependsID <> INVALID) then
    begin
      // Look up dependency and delete it.
      Dependency := Self.DepFromNodeIDDepID(NodeID, DependsID);
      if (Dependency <> INVALID) then
      begin
        Self.DelDependency(Dependency);
      end;
    end;
  end;

  // Main program:
var
  InputList: TStringList; //Lines of dependencies
  TopSort: TTopologicalSort; //Topological sort object
  OutputList: TStringList; //Sorted dependencies
  Counter: integer;
begin

  //Actual sort
  InputList := TStringList.Create;
  // Add rosetta code sample input separated by at least one space in the lines
  InputList.Add(
    'des_system_lib   std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee');
  InputList.Add('dw01             ieee dw01 dware gtech');
  InputList.Add('dw02             ieee dw02 dware');
  InputList.Add('dw03             std synopsys dware dw03 dw02 dw01 ieee gtech');
  InputList.Add('dw04             dw04 ieee dw01 dware gtech');
  InputList.Add('dw05             dw05 ieee dware');
  InputList.Add('dw06             dw06 ieee dware');
  InputList.Add('dw07             ieee dware');
  InputList.Add('dware            ieee dware');
  InputList.Add('gtech            ieee gtech');
  InputList.Add('ramlib           std ieee');
  InputList.Add('std_cell_lib     ieee std_cell_lib');
  InputList.Add('synopsys');
  TopSort := TTopologicalSort.Create;
  OutputList := TStringList.Create;
  try
    TopSort.AddNodeDependencies(InputList); //read in nodes
    TopSort.SortOrder(OutputList); //perform the sort
    for Counter := 0 to OutputList.Count - 1 do
    begin
      writeln(OutputList[Counter]);
    end;
  except
    on E: Exception do
    begin
      Writeln(stderr, 'Error: ', DateTimeToStr(Now),
        ': Error sorting. Technical details: ',
        E.ClassName, '/', E.Message);
    end;
  end; //try
  OutputList.Free;
  TopSort.Free;
  InputList.Free;
end.
