#include <tcl.h>

/* A data structure used to enforce data safety */
struct block {
    int size;
    unsigned char data[4];
};

static int
Memalloc(
    ClientData clientData,
    Tcl_Interp *interp,
    int objc, Tcl_Obj *const *objv)
{
    Tcl_HashTable *nameMap = clientData;
    static int nameCounter = 0;
    char nameBuf[30];
    Tcl_HashEntry *hPtr;
    int size, dummy;
    struct block *blockPtr;

    /* Parse arguments */
    if (objc != 2) {
	Tcl_WrongNumArgs(interp, 1, objv, "size");
	return TCL_ERROR;
    }
    if (Tcl_GetIntFromObj(interp, objv[1], &size) != TCL_OK) {
	return TCL_ERROR;
    }
    if (size < 1) {
	Tcl_AppendResult(interp, "size must be positive", NULL);
	return TCL_ERROR;
    }

    /* The ckalloc() function will panic on failure to allocate. */
    blockPtr = (struct block *)
	    ckalloc(sizeof(struct block) + (unsigned) (size<4 ? 0 : size-4));

    /* Set up block */
    blockPtr->size = size;
    memset(blockPtr->data, 0, blockPtr->size);

    /* Give it a name and return the name */
    sprintf(nameBuf, "block%d", nameCounter++);
    hPtr = Tcl_CreateHashEntry(nameMap, nameBuf, &dummy);
    Tcl_SetHashValue(hPtr, blockPtr);
    Tcl_SetObjResult(interp, Tcl_NewStringObj(nameBuf, -1));
    return TCL_OK;
}

static int
Memfree(
    ClientData clientData,
    Tcl_Interp *interp,
    int objc, Tcl_Obj *const *objv)
{
    Tcl_HashTable *nameMap = clientData;
    Tcl_HashEntry *hPtr;
    struct block *blockPtr;

    /* Parse the arguments */
    if (objc != 2) {
	Tcl_WrongNumArgs(interp, 1, objv, "handle");
	return TCL_ERROR;
    }
    hPtr = Tcl_FindHashEntry(nameMap, Tcl_GetString(objv[1]));
    if (hPtr == NULL) {
	Tcl_AppendResult(interp, "unknown handle", NULL);
	return TCL_ERROR;
    }
    blockPtr = Tcl_GetHashValue(hPtr);

    /* Squelch the memory */
    Tcl_DeleteHashEntry(hPtr);
    ckfree((char *) blockPtr);
    return TCL_OK;
}

static int
Memset(
    ClientData clientData,
    Tcl_Interp *interp,
    int objc, Tcl_Obj *const *objv)
{
    Tcl_HashTable *nameMap = clientData;
    Tcl_HashEntry *hPtr;
    struct block *blockPtr;
    int index, byte;

    /* Parse the arguments */
    if (objc != 4) {
	Tcl_WrongNumArgs(interp, 1, objv, "handle index byte");
	return TCL_ERROR;
    }
    hPtr = Tcl_FindHashEntry(nameMap, Tcl_GetString(objv[1]));
    if (hPtr == NULL) {
	Tcl_AppendResult(interp, "unknown handle", NULL);
	return TCL_ERROR;
    }
    blockPtr = Tcl_GetHashValue(hPtr);
    if (Tcl_GetIntFromObj(interp, objv[2], &index) != TCL_OK
	    || Tcl_GetIntFromObj(interp, objv[3], &byte) != TCL_OK) {
	return TCL_ERROR;
    }
    if (index < 0 || index >= blockPtr->size) {
	Tcl_AppendResult(interp, "index out of range", NULL);
	return TCL_ERROR;
    }

    /* Update the byte of the data block */
    blockPtr->data[index] = (unsigned char) byte;
    return TCL_OK;
}

static int
Memget(
    ClientData clientData,
    Tcl_Interp *interp,
    int objc, Tcl_Obj *const *objv)
{
    Tcl_HashTable *nameMap = clientData;
    Tcl_HashEntry *hPtr;
    struct block *blockPtr;
    int index, byte;

    /* Parse the arguments */
    if (objc != 3) {
	Tcl_WrongNumArgs(interp, 1, objv, "handle index");
	return TCL_ERROR;
    }
    hPtr = Tcl_FindHashEntry(nameMap, Tcl_GetString(objv[1]));
    if (hPtr == NULL) {
	Tcl_AppendResult(interp, "unknown handle", NULL);
	return TCL_ERROR;
    }
    blockPtr = Tcl_GetHashValue(hPtr);
    if (Tcl_GetIntFromObj(interp, objv[2], &index) != TCL_OK) {
	return TCL_ERROR;
    }
    if (index < 0 || index >= blockPtr->size) {
	Tcl_AppendResult(interp, "index out of range", NULL);
	return TCL_ERROR;
    }

    /* Read the byte from the data block and return it */
    Tcl_SetObjResult(interp, Tcl_NewIntObj(blockPtr->data[index]));
    return TCL_OK;
}

static int
Memaddr(
    ClientData clientData,
    Tcl_Interp *interp,
    int objc, Tcl_Obj *const *objv)
{
    Tcl_HashTable *nameMap = clientData;
    Tcl_HashEntry *hPtr;
    struct block *blockPtr;
    int addr;

    /* Parse the arguments */
    if (objc != 2) {
	Tcl_WrongNumArgs(interp, 1, objv, "handle");
	return TCL_ERROR;
    }
    hPtr = Tcl_FindHashEntry(nameMap, Tcl_GetString(objv[1]));
    if (hPtr == NULL) {
	Tcl_AppendResult(interp, "unknown handle", NULL);
	return TCL_ERROR;
    }
    blockPtr = Tcl_GetHashValue(hPtr);

    /* This next line is non-portable */
    addr = (int) blockPtr->data;
    Tcl_SetObjResult(interp, Tcl_NewIntObj(addr));
    return TCL_OK;
}

int
Memalloc_Init(Tcl_Interp *interp)
{
    /* Make the hash table */
    Tcl_HashTable *hashPtr = (Tcl_HashTable *) ckalloc(sizeof(Tcl_HashTable));
    Tcl_InitHashTable(hashPtr, TCL_STRING_KEYS);

    /* Register the commands */
    Tcl_CreateObjCommand(interp, "memalloc", Memalloc, hashPtr, NULL);
    Tcl_CreateObjCommand(interp, "memfree", Memfree, hashPtr, NULL);
    Tcl_CreateObjCommand(interp, "memset", Memset, hashPtr, NULL);
    Tcl_CreateObjCommand(interp, "memget", Memget, hashPtr, NULL);
    Tcl_CreateObjCommand(interp, "memaddr", Memaddr, hashPtr, NULL);

    /* Register the package */
    return Tcl_PkgProvide(interp, "memalloc", "1.0");
}
