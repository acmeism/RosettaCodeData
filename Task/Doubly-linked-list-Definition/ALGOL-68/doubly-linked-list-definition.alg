MODE DATA = STRING; # user defined data type #

MODE MNODE = STRUCT (
  NODE pred,
       succ,
  DATA value
);

MODE LIST = REF MNODE;
MODE NODE = REF MNODE;

STRUCT (
  PROC LIST new list,
  PROC (LIST)BOOL is empty,
  PROC (LIST)NODE get head,
                  get tail,
  PROC (LIST, NODE)NODE add tail,
                            add head,
  PROC (LIST)NODE remove head,
                  remove tail,
  PROC (LIST, NODE, NODE)NODE insert after,
  PROC (LIST, NODE)NODE remove node
) class list;

new list OF class list := LIST: (
  HEAP MNODE master link;
  master link := (master link, master link, ~);
  master link
);

is empty OF class list := (LIST self)BOOL:
  (LIST(pred OF self) :=: LIST(self)) AND (LIST(self) :=: LIST(succ OF self));

get head OF class list := (LIST self)NODE:
  succ OF self;

get tail OF class list := (LIST self)NODE:
  pred OF self;

add tail OF class list := (LIST self, NODE node)NODE:
  (insert after OF class list)(self, pred OF self, node);

add head OF class list := (LIST self, NODE node)NODE:
  (insert after OF class list)(self, succ OF self, node);

remove head OF class list := (LIST self)NODE:
  (remove node OF class list)(self, succ OF self);

remove tail OF class list := (LIST self)NODE:
  (remove node OF class list)(self, pred OF self);

insert after OF class list := (LIST self, NODE cursor, NODE node)NODE: (
  succ OF node := succ OF cursor;
  pred OF node := cursor;
  succ OF cursor := node;
  pred OF succ OF node := node;
  node
);

remove node OF class list := (LIST self, NODE node)NODE: (
  succ OF pred OF node := succ OF node;
  pred OF succ OF node := pred OF node;
  succ OF node := pred OF node := NIL; # garbage collection hint #
  node
);

main: (

    []DATA sample = ("Was", "it", "a", "cat", "I", "saw");

    LIST list a := new list OF class list;

    NODE tmp;

    IF list a :/=: REF LIST(NIL) THEN # technically "list a" is never NIL #
# Add some data to a list #
        FOR i TO UPB sample DO
            tmp := HEAP MNODE;
            IF tmp :/=: NODE(NIL) THEN # technically "tmp" is never NIL #
               value OF tmp := sample[i];
               (add tail OF class list)(list a, tmp)
            FI
        OD;

# Iterate throught the list forward #
        NODE node := (get head OF class list)(list a);
        print("Iterate orward: ");
        WHILE  node :/=: NODE(list a) DO
            print((value OF node, " "));
            node := succ OF node
        OD;
        print(new line);

# Iterate throught the list backward #
        node := (get tail OF class list)(list a);
        print("Iterate backward: ");
        WHILE  node :/=: NODE(list a) DO
            print((value OF node, " "));
            node := pred OF node
        OD;
        print(new line);

# Finally empty the list #
        print("Empty from tail: ");
        WHILE NOT (is empty OF class list)(list a) DO
              tmp := (remove tail OF class list)(list a);
              print((value OF tmp, " "))
              # sweep heap #
        OD;
        print(new line)
        # sweep heap #
    FI
)
