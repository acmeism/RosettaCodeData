#include <stdio.h>
#include <stdlib.h>
#include "pairheap.h"

int wheel2357[48] = {
    10,  2,  4,  2,  4,  6,  2,  6,
     4,  2,  4,  6,  6,  2,  6,  4,
     2,  6,  4,  6,  8,  4,  2,  4,
     2,  4,  8,  6,  4,  6,  2,  4,
     6,  2,  6,  6,  4,  2,  4,  6,
     2,  6,  4,  2,  4,  2, 10,  2,
     };

typedef struct { // elements in the priority queue
    pq_node_t hd;
    int       offset;      // index to skip value in 2,3,5,7 wheel
    long int  base_prime;
} w2357_multiples;

typedef struct {
    int      start_ndx;
    int      offset;
    long int candidate;
    heap_t   composites;
    int      count;      // count of primes returned.
} primegen_t;

primegen_t make_pgen() {
    w2357_multiples *composites;
    primegen_t gen;

    gen.start_ndx = 0;  // primes 2, 3, 5, 7, 11
    NEW_PQ_ELE(composites, 121);
    gen.offset = composites->offset = 1;
    gen.candidate = composites->base_prime = 11;
    gen.composites = (heap_t) composites;
    gen.count = 0;
    return gen;
}

long int next_prime(primegen_t *gen) {
    static short upto11[] = {
        2, 3, 5, 7, 11
        };
    if (gen->start_ndx < 5) {
        ++gen->count;
        return upto11[gen->start_ndx++];
    } else {
        for (;;) {
            // advance to the next prime candidate.
            gen->candidate += wheel2357[gen->offset++];
            if (gen->offset == 48)
                gen->offset = 0;

            // See if the composite number on top of the heap matches
            // the candidate.
            //
            w2357_multiples *top = (w2357_multiples *) gen->composites;
            if (top->hd.key == gen->candidate) { // not prime
                do {
                    // advance the top of heap to the next prime multiple
                    // that is not a multiple of 2, 3, 5, 7.
                    //
                    gen->composites = heap_pop(gen->composites);
                    top->hd.next = top->hd.down = NULL;
                    top->hd.key += top->base_prime  * wheel2357[top->offset++];
                    if (top->offset == 48)
                        top->offset = 0;
                    gen->composites = heap_merge((heap_t) top, gen->composites);
                    top = (w2357_multiples *) gen->composites;
                } while (top->hd.key == gen->candidate);
            } else {
                // prime found, add the square and it's position on the wheel
                // to the heap.
                //
                w2357_multiples *new;
                HEAP_PUSH(
                    new,
                    gen->candidate * gen->candidate,
                    &gen->composites);
                new->offset = gen->offset;
                new->base_prime = gen->candidate;
                ++gen->count;
                return gen->candidate;
            }
        }
    }
}

int main() {
    primegen_t primes = make_pgen();
    printf("first 20: ");
    for (int i = 1; i <= 20; i++)
        printf("%ld ", next_prime(&primes));
    putchar('\n');

    printf("between 100 and 150: ");
    long int p = next_prime(&primes);
    while (p < 150) {
        if (p > 100)
            printf("%ld ", p);
        p = next_prime(&primes);
    }
    putchar('\n');

    int count = 0;
    while (p < 8000) {
        if (p > 7700)
            ++count;
        p = next_prime(&primes);
    }
    printf("%d primes between 7700 and 8000.\n", count);

    long c;
    for (c = 10000; c <= 10000000; c *= 10) {
        while (primes.count < c)
            p = next_prime(&primes);
        printf("%ldth prime is %ld\n", c, p);
    }


    return 0;
}
