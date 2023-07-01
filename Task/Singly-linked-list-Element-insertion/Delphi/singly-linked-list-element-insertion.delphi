// Using the same type defs from the one way list example.

Type

  // The pointer to the list structure
  pOneWayList = ^OneWayList;

  // The list structure
  OneWayList = record
                 pData : pointer ;
                 Next  : pOneWayList ;
               end;

// I will illustrate a simple function that will return a pointer to the
// new node or it will return NIL.  In this example I will always insert
// right, to keep the code clear.  Since I am using a function all operations
// for the new node will be conducted on the functions result.  This seems
// somewhat counter intuitive, but it is the simplest way to accomplish this.

Function InsertNode(VAR CurrentNode:pOneWayList): pOneWayList
begin

    // I try not to introduce different parts of the language, and keep each
    // example to just the code required.  in this case it is important to use
    // a try/except block.  In any OS that is multi-threaded and has many apps
    // running at the same time, you cannot rely on a call to check memory available
    // and then attempting to allocate.  In the time between the two, another
    // program may have grabbed the memory you were trying to get.

    Try
      // Try to allocate enough memory for a variable the size of OneWayList
      GetMem(Result,SizeOf(OneWayList));
    Except
      On EOutOfMemoryError do
         begin
           Result := NIL
           exit;
         end;
    end;

    // Initialize the variable.
    Result.Next  := NIL ;
    Reuslt.pdata := NIL ;

    // Ok now we will insert to the right.

    // Is the Next pointer of CurrentNode Nil?  If it is we are just tacking
    // on to the end of the list.

    if CurrentNode.Next = NIL then
       CurrentNode.Next := Result
    else
      // We are inserting into the middle of this list
      Begin
         Result.Next      := CurrentNode.Next ;
         CurrentNode.Next := result ;
      end;
end;
