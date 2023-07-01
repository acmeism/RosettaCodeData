MODE VALUE = INT;
PROC value repr = (VALUE value)STRING: whole(value, 0);

MODE NODES = STRUCT ( VALUE value, REF NODES left, right);
MODE NODE = REF NODES;

PROC tree = (VALUE value, NODE left, right)NODE:
  HEAP NODES := (value, left, right);

PROC preorder = (NODE node, PROC (VALUE)VOID action)VOID:
  IF node ISNT NODE(NIL) THEN
    action(value OF node);
    preorder(left OF node, action);
    preorder(right OF node, action)
  FI;

PROC inorder = (NODE node, PROC (VALUE)VOID action)VOID:
  IF node ISNT NODE(NIL) THEN
    inorder(left OF node, action);
    action(value OF node);
    inorder(right OF node, action)
  FI;

PROC postorder = (NODE node, PROC (VALUE)VOID action)VOID:
  IF node ISNT NODE(NIL) THEN
    postorder(left OF node, action);
    postorder(right OF node, action);
    action(value OF node)
  FI;

PROC destroy tree = (NODE node)VOID:
  postorder(node, (VALUE skip)VOID:
  # free(node) - PR garbage collect hint PR #
    node := (SKIP, NIL, NIL)
  );

# helper queue for level order #
MODE QNODES = STRUCT (REF QNODES next, NODE value);
MODE QNODE = REF QNODES;


MODE QUEUES = STRUCT (QNODE begin, end);
MODE QUEUE = REF QUEUES;

PROC enqueue = (QUEUE queue, NODE node)VOID:
(
  HEAP QNODES qnode := (NIL, node);
  IF end OF queue ISNT QNODE(NIL) THEN
    next OF end OF queue
  ELSE
    begin OF queue
  FI := end OF queue := qnode
);

PROC queue empty = (QUEUE queue)BOOL:
  begin OF queue IS QNODE(NIL);

PROC dequeue = (QUEUE queue)NODE:
(
  NODE out := value OF begin OF queue;
  QNODE second := next OF begin OF queue;
# free(begin OF queue); PR garbage collect hint PR #
  QNODE(begin OF queue) := (NIL, NIL);
  begin OF queue := second;
  IF queue empty(queue) THEN
    end OF queue := begin OF queue
  FI;
  out
);

PROC level order = (NODE node, PROC (VALUE)VOID action)VOID:
(
  HEAP QUEUES queue := (QNODE(NIL), QNODE(NIL));
  enqueue(queue, node);
  WHILE NOT queue empty(queue)
  DO
    NODE next := dequeue(queue);
    IF next ISNT NODE(NIL) THEN
      action(value OF next);
      enqueue(queue, left OF next);
      enqueue(queue, right OF next)
    FI
  OD
);

PROC print node = (VALUE value)VOID:
  print((" ",value repr(value)));

main: (
  NODE node := tree(1,
                tree(2,
                     tree(4,
                          tree(7, NIL, NIL),
                          NIL),
                     tree(5, NIL, NIL)),
                tree(3,
                     tree(6,
                          tree(8, NIL, NIL),
                          tree(9, NIL, NIL)),
                     NIL));

  MODE TEST = STRUCT(
    STRING name,
    PROC(NODE,PROC(VALUE)VOID)VOID order
  );

  PROC test = (TEST test)VOID:(
    STRING pad=" "*(12-UPB name OF test);
    print((name OF test,pad,": "));
    (order OF test)(node, print node);
    print(new line)
  );

  []TEST test list = (
    ("preorder",preorder),
    ("inorder",inorder),
    ("postorder",postorder),
    ("level order",level order)
  );

  FOR i TO UPB test list DO test(test list[i]) OD;

  destroy tree(node)
)
