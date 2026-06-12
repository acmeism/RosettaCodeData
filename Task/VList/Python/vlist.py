from typing import Optional, Self

class VList[T]:
    """
    A custom linked-list-like structure that stores elements in variable-length
    array segments (kind of like a hybrid between a list and a cons cell).
    """

    class _VSegment[T]:
        """
        Internal helper class representing one "segment" of the `VList`.
        Each segment holds a list of elements and a pointer to the next segment.
        """

        def __init__(self, next: Optional["VList._VSegment"] = None, elements: Optional[list[T]] = []):
            self.next = next  # The next segment in the chain
            self.elements = elements if elements is not None else []  # Elements stored in this segment

    def __init__(self):
        """
        Initialise an empty `VList` with a base segment and `offset` = 0.
        Offset indicates the index of the "current head" of the `VList`
        within the base segment.
        """
        self.base = self._VSegment()
        self.base.elements = []
        self.offset = 0

    def cons(self, element: T) -> Self:
        """
        Add (prepend) an element to the `VList`, returning the updated list.
        Similar to Lisp's `cons`.
        """
        # Case 1: Empty list -> just insert into base segment
        if len(self.base.elements) == 0:
            self.base.elements.append(element)
            return self

        # Case 2: No space left at the current offset -> create a new segment
        if self.offset == 0:
            self.offset = len(self.base.elements) * 2 - 1  # Calculate new offset
            segment = self._VSegment()
            segment.next = self.base
            segment.elements = [None] * self.offset  # Preallocate with `None`
            segment.elements.append(element)  # Add new element at the end
            self.base = segment

            return self

        # Case 3: Place the new element at `offset - 1` in the current segment
        self.offset -= 1
        self.base.elements[self.offset] = element
        return self

    def cdr(self) -> Self:
        """
        Remove (drop) the first element of the `VList`, returning the updated list.
        Similar to Lisp's `cdr`.
        """
        if len(self.base.elements) == 0:
            raise AssertionError("cdr invoked on an empty VList")

        # Advance the offset to skip the first element
        self.offset += 1
        if self.offset < len(self.base.elements):
            return self

        # If we've consumed the whole segment, move to the next one
        self.offset = 0
        self.base = self.base.next
        return self

    def __getitem__(self, key: int) -> T:
        """
        Retrieve an element by index (0-based).
        Traverses segments if needed.
        """
        if key >= 0:
            index = key + self.offset
            segment = self.base

            while segment is not None:
                if index < len(segment.elements):
                    return segment.elements[index]

                # Skip to next segment if index exceeds current segment length
                index -= len(segment.elements)
                segment = segment.next

        raise IndexError(f"Index out of range: {key}")

    def __len__(self) -> int:
        """
        Return the total number of elements in the `VList`.
        Uses the formula: `segment_length * 2 - offset - 1`.
        """
        return 0 if len(self.base.elements) == 0 else len(self.base.elements) * 2 - self.offset - 1

    def __str__(self) -> str:
        """
        Return a string representation of the VList in list form.

        Example:

        ```
        [1 2 3 4]
        ```
        """
        if len(self.base.elements) == 0:
            return "[]"

        first = self.base.elements[self.offset]
        result = f"[{first}"
        segment = self.base
        elementsSubList = segment.elements[self.offset+1:len(segment.elements)]

        while True:
            for element in elementsSubList:
                result += f" {element}"
            segment = segment.next
            if segment == None:
                break
            elementsSubList = segment.elements

        result += "]"

        return result

    def showStructure(self):
        """
        Print a debug view of the internal structure of the `VList`:

        * The current offset
        * All segments and their raw contents
        """
        segment = self.base

        result = f"Offset: {self.offset}\n"
        while segment != None:
            result += str(segment.elements) + "\n"
            segment = segment.next

        print(result)

# Demonstration of how the `VList` works
if __name__ == "__main__":
    vList = VList()

    print(f"Before adding any elements, the VList is empty: {vList}")
    vList.showStructure()

    # Add elements 6 down to 1
    for i in range(6, 0, -1):
        vList = vList.cons(i)

    print(f"Demonstrating cons method, 6 elements added: {vList}")
    vList.showStructure()

    # Remove the head element
    vList = vList.cdr()
    print(f"Demonstrating cons method, 1 element removed: {vList}")
    vList.showStructure()

    # Show size and random access
    print(f"Demonstrating size property, size = {len(vList)}")
    print(f"Demonstrating element access, v[3] = {vList[3]}")

    # Remove 2 more elements
    vList = vList.cdr().cdr()

    print(f"Demonstrating cdr method again, 2 more elements removed: {vList}")
    vList.showStructure()
