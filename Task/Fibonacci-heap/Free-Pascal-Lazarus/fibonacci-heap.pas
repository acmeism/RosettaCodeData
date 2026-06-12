program FibonacciHeap;
{$mode objfpc}

type
  // A pointer to a node in the heap
  PNode = ^TNode;

  // The node structure containing key, degree, parent, child, and linked nodes
  TNode = record
    Key: integer;      // The key value of the node
    Degree: integer;   // The degree of the node (number of children)
    Parent, Child, Left, Right: PNode;  // Pointers for the doubly linked circular list
    Marked: boolean;   // Whether the node is marked
  end;

  // Fibonacci Heap class definition
  TFibonacciHeap = class
  private
    MinNode: PNode;    // Points to the node with the minimum key in the heap
    NodeCount: integer; // The number of nodes in the heap
    function FindNode(Root: PNode; Key: integer): PNode; // Finds a node by key in the heap
    procedure PrintHeapRecursive(Node: PNode; Indent: integer); // Recursively prints the heap structure
  public
    constructor Create; // Constructor to initialize the heap
    procedure Insert(Key: integer); // Inserts a new key into the heap
    function FindMin: integer; // Returns the minimum key in the heap
    procedure DecreaseKey(Node: PNode; NewKey: integer); // Decreases the key of a given node
    function ExtractMin: integer; // Extracts the minimum key node from the heap
    procedure Delete(Key: integer); // Deletes a node with the specified key
    procedure Union(OtherHeap: TFibonacciHeap); // Unites the current heap with another heap
    procedure PrintHeap; // Prints the entire heap structure
  end;

  // Constructor: Initializes an empty Fibonacci heap
  constructor TFibonacciHeap.Create;
  begin
    MinNode := nil;  // No nodes initially
    NodeCount := 0;  // Node count is 0 initially
  end;

  // Inserts a new key into the Fibonacci heap
  procedure TFibonacciHeap.Insert(Key: integer);
  var
    NewNode: PNode;
  begin
    // Create a new node
    New(NewNode);
    NewNode^.Key := Key;
    NewNode^.Degree := 0;
    NewNode^.Parent := nil;
    NewNode^.Child := nil;
    NewNode^.Marked := False;
    NewNode^.Left := NewNode;
    NewNode^.Right := NewNode;

    // If the heap is empty, the new node becomes the MinNode
    if MinNode = nil then
      MinNode := NewNode
    else
    begin
      // Insert the new node into the root list
      NewNode^.Right := MinNode^.Right;
      NewNode^.Left := MinNode;
      MinNode^.Right^.Left := NewNode;
      MinNode^.Right := NewNode;

      // Update the MinNode if necessary
      if NewNode^.Key < MinNode^.Key then
        MinNode := NewNode;
    end;

    // Increase the node count
    Inc(NodeCount);
  end;

  // Finds the minimum key in the heap (returns -1 if empty)
  function TFibonacciHeap.FindMin: integer;
  begin
    if MinNode <> nil then
      Result := MinNode^.Key
    else
      Result := -1; // Return -1 for an empty heap
  end;

  // Decreases the key of a given node
  procedure TFibonacciHeap.DecreaseKey(Node: PNode; NewKey: integer);
  begin
    if Node = nil then Exit;

    // Check if the new key is smaller than the current key
    if NewKey > Node^.Key then
    begin
      Writeln('Error: New key is greater than current key.');
      Exit;
    end;

    // Update the key
    Node^.Key := NewKey;

    // If the node violates the heap property, move it to the root list
    if (Node^.Parent <> nil) and (Node^.Key < Node^.Parent^.Key) then
      Node^.Parent := nil;

    // Update the minimum node if necessary
    if Node^.Key < MinNode^.Key then
      MinNode := Node;
  end;

  // Extracts and returns the minimum key node from the heap
  function TFibonacciHeap.ExtractMin: integer;
  begin
    if MinNode = nil then
    begin
      Result := -1;
      Exit;
    end;

    Result := MinNode^.Key; // Return the key of the minimum node

    // If there is only one node, set MinNode to nil
    if MinNode^.Right = MinNode then
      MinNode := nil
    else
    begin
      // Remove the minimum node from the root list
      MinNode^.Left^.Right := MinNode^.Right;
      MinNode^.Right^.Left := MinNode^.Left;
      MinNode := MinNode^.Right; // Update MinNode to the next node
    end;

    // Decrease the node count
    Dec(NodeCount);
  end;

  // Finds a node by key starting from the root node
  function TFibonacciHeap.FindNode(Root: PNode; Key: integer): PNode;
  var
    Temp, ResultNode: PNode;
  begin
    Result := nil;
    if Root = nil then Exit;

    Temp := Root;
    repeat
      if Temp^.Key = Key then
      begin
        Result := Temp;
        Exit;
      end;

      // Recursively search children
      if Temp^.Child <> nil then
      begin
        ResultNode := FindNode(Temp^.Child, Key);
        if ResultNode <> nil then
        begin
          Result := ResultNode;
          Exit;
        end;
      end;

      // Move to the next node in the root list
      Temp := Temp^.Right;
    until Temp = Root;
  end;

  // Deletes a node by key by first decreasing its key to a very small value and then extracting it
  procedure TFibonacciHeap.Delete(Key: integer);
  var
    NodeToDelete: PNode;
  begin
    NodeToDelete := FindNode(MinNode, Key);
    if NodeToDelete <> nil then
    begin
      DecreaseKey(NodeToDelete, -MaxInt);  // Decrease key to the smallest possible value
      ExtractMin;  // Extract the node from the heap
    end;
  end;

  // Unites two Fibonacci heaps by merging their root lists
  procedure TFibonacciHeap.Union(OtherHeap: TFibonacciHeap);
  var
    Temp: PNode;
  begin
    if OtherHeap = nil then Exit;
    if OtherHeap.MinNode = nil then Exit;
    if MinNode = nil then
    begin
      MinNode := OtherHeap.MinNode;  // If current heap is empty, adopt the other heap's MinNode
      NodeCount := OtherHeap.NodeCount;
      Exit;
    end;

    // Merge the root lists of both heaps
    Temp := MinNode^.Right;
    MinNode^.Right := OtherHeap.MinNode^.Right;
    MinNode^.Right^.Left := MinNode;
    OtherHeap.MinNode^.Right := Temp;
    Temp^.Left := OtherHeap.MinNode;

    // Update the MinNode if necessary
    if OtherHeap.MinNode^.Key < MinNode^.Key then
      MinNode := OtherHeap.MinNode;

    // Adjust the node count
    Inc(NodeCount, OtherHeap.NodeCount);

    // Clear the other heap
    OtherHeap.MinNode := nil;
    OtherHeap.NodeCount := 0;
  end;

  // Recursive function to print the heap's structure
  procedure TFibonacciHeap.PrintHeapRecursive(Node: PNode; Indent: integer);
  var
    StartNode, Current: PNode;
    I: integer;
  begin
    if Node = nil then Exit;

    StartNode := Node;
    Current := Node;

    repeat
      // Indent and print the node key
      for I := 1 to Indent do
        Write('  ');
      Writeln(Current^.Key);

      // Print the children recursively
      if Current^.Child <> nil then
      begin
        for I := 1 to Indent do
          Write('  ');
        Writeln('Children of ', Current^.Key, ':');
        PrintHeapRecursive(Current^.Child, Indent + 2);
      end;

      // Move to the next node in the root list
      Current := Current^.Right;
    until Current = StartNode;
  end;

  // Prints the entire heap using recursion
  procedure TFibonacciHeap.PrintHeap;
  begin
    if MinNode = nil then
    begin
      Writeln('Heap is empty.');
      Exit;
    end;

    Writeln('Fibonacci Heap:');
    PrintHeapRecursive(MinNode, 0);  // Start printing from the MinNode
    writeln;
  end;

var
  Heap1, Heap2: TFibonacciHeap;
  node: PNode;
begin
  // Create two Fibonacci heaps
  Heap1 := TFibonacciHeap.Create;
  Heap2 := TFibonacciHeap.Create;

  // Insert nodes into Heap1
  Heap1.Insert(10);
  Heap1.Insert(5);
  Heap1.Insert(20);
  Heap1.Insert(99);

  writeln('Heap 1 minimum = ', Heap1.FindMin);
  Heap1.PrintHeap;

  writeln('Heap 1 extract minimum = ', Heap1.ExtractMin);
  Heap1.PrintHeap;

  // Decrease key in Heap1
  node := Heap1.FindNode(Heap1.MinNode, 20);
  Heap1.DecreaseKey(node, 3);
  writeln('Heap 1 after changing key 20 to 3');
  Heap1.PrintHeap;

  // Insert nodes into Heap2
  Heap2.Insert(15);
  Heap2.Insert(2);

  writeln('Heap 2 before union:');
  Heap2.PrintHeap;

  // Perform union of Heap1 and Heap2
  Heap1.Union(Heap2);

  writeln('Heap after union:');
  Heap1.PrintHeap;

  // Free the heaps
  Heap1.Free;
  Heap2.Free;
end.


