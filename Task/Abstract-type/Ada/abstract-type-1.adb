type Queue is limited interface;
procedure Enqueue (Lounge : in out Queue; Item : in out Element) is abstract;
procedure Dequeue (Lounge : in out Queue; Item : in out Element) is abstract;
