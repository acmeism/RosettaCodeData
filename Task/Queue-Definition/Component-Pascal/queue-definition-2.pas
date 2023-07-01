DEFINITION Queue;

	IMPORT Boxes;

	TYPE
		Instance = POINTER TO LIMITED RECORD
			(self: Instance) Capacity (): LONGINT, NEW;
			(self: Instance) IsEmpty (): BOOLEAN, NEW;
			(self: Instance) IsFull (): BOOLEAN, NEW;
			(self: Instance) Pop (): Boxes.Box, NEW;
			(self: Instance) Push (b: Boxes.Box), NEW;
			(self: Instance) Size (): LONGINT, NEW
		END;

	PROCEDURE New (capacity: LONGINT): Instance;

END Queue.
