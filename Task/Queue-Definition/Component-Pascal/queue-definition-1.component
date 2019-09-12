MODULE Queue;
IMPORT
	Boxes;
TYPE
	Instance* = POINTER TO LIMITED RECORD
		size: LONGINT;
		first,last: LONGINT;
		_queue: POINTER TO ARRAY OF Boxes.Box;
	END;
	
	PROCEDURE (self: Instance) Initialize(capacity: LONGINT),NEW;
	BEGIN
		self.size := 0;
		self.first := 0;
		self.last := 0;
		NEW(self._queue,capacity)
	END Initialize;
	
	PROCEDURE New*(capacity: LONGINT): Instance;
	VAR
		aQueue: Instance;
	BEGIN
		NEW(aQueue);aQueue.Initialize(capacity);RETURN aQueue
	END New;
	
	PROCEDURE (self: Instance) IsEmpty*(): BOOLEAN, NEW;
	BEGIN
		RETURN self.size = 0;
	END IsEmpty;
	
	PROCEDURE (self: Instance) Capacity*(): LONGINT, NEW;
	BEGIN
		RETURN LEN(self._queue)
	END Capacity;
	
	PROCEDURE (self: Instance) Size*(): LONGINT, NEW;
	BEGIN
		RETURN self.size
	END Size;
	
	PROCEDURE (self: Instance) IsFull*(): BOOLEAN, NEW;
	BEGIN
		RETURN self.size = self.Capacity()
	END IsFull;
	
	PROCEDURE (self: Instance) Push*(b: Boxes.Box), NEW;
	VAR
		i, j, newCapacity, oldSize: LONGINT;
		queue: POINTER TO ARRAY OF Boxes.Box;
	BEGIN
		INC(self.size);
		self._queue[self.last] := b;
		self.last := (self.last + 1) MOD self.Capacity();
		IF self.IsFull() THEN
			(* grow queue *)
			newCapacity := self.Capacity() + (self.Capacity() DIV 2);
			(* new queue *)
			NEW(queue,newCapacity);
			(* move data from old to new queue *)
			i := self.first; j := 0; oldSize := self.Capacity() - self.first + self.last;
			WHILE (j < oldSize) & (j < newCapacity - 1) DO
				queue[j] := self._queue[i];
				i := (i + 1) MOD newCapacity;INC(j)
			END;
			self._queue := queue;self.first := 0;self.last := j
		END
	END Push;
	
	PROCEDURE (self: Instance) Pop*(): Boxes.Box, NEW;
	VAR
		b: Boxes.Box;
	BEGIN
		ASSERT(~self.IsEmpty());
		DEC(self.size);
		b := self._queue[self.first];
		self._queue[self.first] := NIL;
		self.first := (self.first + 1) MOD self.Capacity();
		RETURN b
	END Pop;
	
END Queue.
