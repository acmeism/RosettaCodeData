MODULE RosettaVLists;
(** In 2002, Phil Bagwell published "Fast Functional Lists" which introduced VLists as alternatives to Functional Programming's
ubiquitous linked lists and described Visp (a dialect of  Common Lisp) using VLists, but including a "foldr" function,
optimized to use VLists.  VLists have the same properties as immutable functional linked lists (including full persistence); but,
unlike a linked list, with O(1) random access time. The VLists implemented here is based on section 2.1 of that article but has been
modified to retain the safety features of Component Pascal.

VLists are referenced through 2 fields: "base" and "offset".  A third field "length" reduces the  time to determine its length to O(1).

Methods provided for manipulating VLists are named after their corresponding Visp functions, but follow Component Pascal's case conventions. **)

    TYPE
        Element* = CHAR; (** "Element" could be defined as a generic type.
        To demonstrate strings, it is defined as a character. **)

        Accum* = ABSTRACT RECORD END; (** For use in "FoldR" **)

        Out* = ABSTRACT RECORD END; (** For use in "Exp" **)

        Link = RECORD base: Base; offset: INTEGER END;

        Base = POINTER TO RECORD
            link: Link;
            lastUsed: INTEGER;
            block: POINTER TO ARRAY OF Element
        END;

        List* = RECORD
            link: Link;
            length-: INTEGER (** the length of the list **)
        END;
        (* The field "length" (read-only outside this module) has been added to "List".
        This reduces the  time to determine the VList's length to O(1). *)
        (* primary operation #4: the length of the VList. *)

    VAR
        nilBase: Base;

    (** Used for processing an element in "FoldR" **)
    PROCEDURE (VAR a: Accum) Do- (e: Element), NEW, ABSTRACT;

    (** Process the elements of "l" in reverse **)
    PROCEDURE (IN l: List) FoldR* (VAR a: Accum), NEW;
    (* Uses only O(log n) storage for pointers *)

        PROCEDURE Aux (IN k: Link; len: INTEGER);
            VAR i: INTEGER;
        BEGIN
            IF len = 0 THEN RETURN END;
            Aux(k.base.link, len - k.offset - 1);
            FOR i := 0 TO k.offset DO
                a.Do(k.base.block[i])
            END
        END Aux;

    BEGIN
        Aux(l.link, l.length)
    END FoldR;

    (** Returns the first element of "l".  It is an error for "l" be empty. **)
    PROCEDURE (IN l: List) Car* (): Element, NEW;
    (* An indirect load via the list "link". *)
    BEGIN
        ASSERT(l.length > 0);
        RETURN l.link.base.block[l.link.offset]
    END Car;

    (** Returns the "n"th element of "l". It is an error for "n" to be negative or at least
    "l.length". **)
    PROCEDURE (IN l: List) Nth* (n: INTEGER): Element, NEW;
    (* primary operation #1 *)
        VAR k: Link;
    BEGIN
        ASSERT(0 <= n); ASSERT(n < l.length);
        k := l.link;
        WHILE n > k.offset DO
            DEC(n, k.offset + 1);
            k := k.base.link
        END;
        RETURN k.base.block[k.offset - n]
    END Nth;

    PROCEDURE (b: Base) NewBlock (size: INTEGER; e: Element), NEW;
    BEGIN
        b.lastUsed := 0; NEW(b.block, size); b.block[0] := e
    END NewBlock;

    (** Prefix "e" to "l". **)
    PROCEDURE (VAR l: List) Cons* (e: Element), NEW;
    (* primary operation #2 *)

        PROCEDURE NewBase (size: INTEGER);
            VAR b: Base;
        BEGIN
            NEW(b); b.link := l.link; b.NewBlock(size, e);
            l.link.base := b; l.link.offset := 0
        END NewBase;

    BEGIN
        INC(l.length);
        IF l.link.base = NIL THEN
            ASSERT(l.length = 1); NewBase(1)
        ELSIF l.link.offset + 1 = LEN(l.link.base.block) THEN
            (* If there is no room in "block" then a new "Base", with its length doubled in
            size, is added and the new entry made. *)
            NewBase(2 * LEN(l.link.base.block))
        ELSIF l.link.offset = l.link.base.lastUsed THEN
        (* "offset" is compared with "lastUsed". If they are the same and there is still
        room in "block", they are simply both incremented and the new entry made. *)
            INC(l.link.offset); (* Increment "offset". *)
            INC(l.link.base.lastUsed); (* Increment "lastUsed". *)
            l.link.base.block[l.link.offset] := e (* New entry. *)
        ELSIF l.link.base.block[l.link.offset + 1] = e THEN
        (* If the next location happens to contain an element identical to the new element.
        only "offset" is incremented *)
            INC(l.link.offset) (* Increment "offset". *)
        ELSE
        (* If "offset" is less than "lastUsed", "Cons" is being applied to the tail of a
        longer vlist. In this case a new "Base" must be allocated and its "link" set to the
        tail contained in the original list with "offset" being set to the point in this tail
        and the new entry made.  The two lists now share a common tail, as would have
        been the case with a linked list implementation. *)
            NewBase(1)
        END
    END Cons;

    (** Remove the first element of "l". Unlike Common Lisp it is an error for "l" be empty. **)
    PROCEDURE (VAR l: List) Cdr* (), NEW;
    (* primary operation #3 *)
    (* Follow "link" to the next "Base" if "offset" of "link" is 0 else decrement
    "offset" of "link" *)
    BEGIN
        ASSERT(l.length > 0); DEC(l.length);
        IF l.link.offset = 0 THEN
            l.link := l.link.base.link (* Follow "link" to the next "Base". *)
        ELSE
            DEC(l.link.offset) (* Decrement "offset" of "link". *)
        END
    END Cdr;

    (** Remove the first "n" elements of "l".  It is an error for "n" to be negative or at
    least "l.length".  Except for performance, equivalent to performing "n" "Cdr"s **)
    PROCEDURE (VAR l: List) NthCdr* (n: INTEGER), NEW;
        VAR k: Link;
    BEGIN
        ASSERT(0 <= n); ASSERT(n < l.length); DEC(l.length, n);
        k := l.link;
        WHILE n > k.offset DO
            DEC(n, k.offset + 1);
            k := k.base.link
        END;
        l.link.base := k.base; l.link.offset := k.offset - n;
    END NthCdr;

    (** initialise "l" to the empty list **)
    PROCEDURE (VAR l: List) Init*, NEW;
    BEGIN
        l.link.base := nilBase; l.link.offset := -1;
        l.length := 0
    END Init;

    (** Used for outputting in "Exp" **)
    PROCEDURE (IN o: Out) Char- (e: Element), NEW, ABSTRACT;

    (** "Expose" exposes the structure of "l" by outputting it, separating the blocks
    with '┃' characters **)
    PROCEDURE (IN l: List) Expose* (IN o: Out), NEW;
        VAR k: Link; len, i: INTEGER;
    BEGIN
        k := l.link; len := l.length;
        IF len = 0 THEN RETURN END;
        LOOP
            FOR i := k.offset TO 0 BY -1 DO
                o.Char(k.base.block[i])
            END;
            DEC(len, k.offset+1);
            IF len = 0 THEN RETURN END;
            o.Char('┃');
            k := k.base.link
        END
    END Expose;

BEGIN
    NEW(nilBase); nilBase.NewBlock(1, '*')
END RosettaVLists.
