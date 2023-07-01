#include <sys/mman.h>
#include <unistd.h>
#include <stdio.h>

// VERY rudimentary C memory management independent of C library's malloc.

// Linked list (yes, this is inefficient)
struct __ALLOCC_ENTRY__
{
    void * allocatedAddr;
    size_t size;
    struct __ALLOCC_ENTRY__ * next;
};
typedef struct __ALLOCC_ENTRY__ __ALLOCC_ENTRY__;

// Keeps track of allocated memory and metadata
__ALLOCC_ENTRY__ * __ALLOCC_ROOT__ = NULL;
__ALLOCC_ENTRY__ * __ALLOCC_TAIL__ = NULL;

// Add new metadata to the table
void _add_mem_entry(void * location, size_t size)
{

    __ALLOCC_ENTRY__ * newEntry = (__ALLOCC_ENTRY__ *) mmap(NULL, sizeof(__ALLOCC_ENTRY__), PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

    if (__ALLOCC_TAIL__ != NULL)
    {
        __ALLOCC_TAIL__ -> next = newEntry;
        __ALLOCC_TAIL__ = __ALLOCC_TAIL__ -> next;
    }
    else
    {
        // Create new table
        __ALLOCC_ROOT__ = newEntry;
        __ALLOCC_TAIL__ = newEntry;
    }

    __ALLOCC_ENTRY__ * tail = __ALLOCC_TAIL__;
    tail -> allocatedAddr = location;
    tail -> size = size;
    tail -> next = NULL;
    __ALLOCC_TAIL__ = tail;
}

// Remove metadata from the table given pointer
size_t _remove_mem_entry(void * location)
{
    __ALLOCC_ENTRY__ * curNode = __ALLOCC_ROOT__;

    // Nothing to do
    if (curNode == NULL)
    {
        return 0;
    }

    // First entry matches
    if (curNode -> allocatedAddr == location)
    {
        __ALLOCC_ROOT__ = curNode -> next;
        size_t chunkSize = curNode -> size;

        // No nodes left
        if (__ALLOCC_ROOT__ == NULL)
        {
            __ALLOCC_TAIL__ = NULL;
        }
        munmap(curNode, sizeof(__ALLOCC_ENTRY__));

        return chunkSize;
    }

    // If next node is null, remove it
    while (curNode -> next != NULL)
    {
        __ALLOCC_ENTRY__ * nextNode = curNode -> next;

        if (nextNode -> allocatedAddr == location)
        {
            size_t chunkSize = nextNode -> size;

            if(curNode -> next == __ALLOCC_TAIL__)
            {
                __ALLOCC_TAIL__ = curNode;
            }
            curNode -> next = nextNode -> next;
            munmap(nextNode, sizeof(__ALLOCC_ENTRY__));

            return chunkSize;
        }

        curNode = nextNode;
    }

    // Nothing was found
    return 0;
}

// Allocate a block of memory with size
// When customMalloc an already mapped location, causes undefined behavior
void * customMalloc(size_t size)
{
    // Now we can use 0 as our error state
    if (size == 0)
    {
        return NULL;
    }

    void * mapped = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

    // Store metadata
    _add_mem_entry(mapped, size);

    return mapped;
}

// Free a block of memory that has been customMalloc'ed
void customFree(void * addr)
{
    size_t size = _remove_mem_entry(addr);

    munmap(addr, size);
}

int main(int argc, char const *argv[])
{
    int *p1 = customMalloc(4*sizeof(int));  // allocates enough for an array of 4 int
    int *p2 = customMalloc(sizeof(int[4])); // same, naming the type directly
    int *p3 = customMalloc(4*sizeof *p3);   // same, without repeating the type name

    if(p1) {
        for(int n=0; n<4; ++n) // populate the array
            p1[n] = n*n;
        for(int n=0; n<4; ++n) // print it back out
            printf("p1[%d] == %d\n", n, p1[n]);
    }

    customFree(p1);
    customFree(p2);
    customFree(p3);

    return 0;
}
