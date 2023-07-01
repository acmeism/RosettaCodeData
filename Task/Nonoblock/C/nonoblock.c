#include <stdio.h>
#include <string.h>

void nb(int cells, int total_block_size, int* blocks, int block_count,
        char* output, int offset, int* count) {
    if (block_count == 0) {
        printf("%2d  %s\n", ++*count, output);
        return;
    }
    int block_size = blocks[0];
    int max_pos = cells - (total_block_size + block_count - 1);
    total_block_size -= block_size;
    cells -= block_size + 1;
    ++blocks;
    --block_count;
    for (int i = 0; i <= max_pos; ++i, --cells) {
        memset(output + offset, '.', max_pos + block_size);
        memset(output + offset + i, '#', block_size);
        nb(cells, total_block_size, blocks, block_count, output,
           offset + block_size + i + 1, count);
    }
}

void nonoblock(int cells, int* blocks, int block_count) {
    printf("%d cells and blocks [", cells);
    for (int i = 0; i < block_count; ++i)
        printf(i == 0 ? "%d" : ", %d", blocks[i]);
    printf("]:\n");
    int total_block_size = 0;
    for (int i = 0; i < block_count; ++i)
        total_block_size += blocks[i];
    if (cells < total_block_size + block_count - 1) {
        printf("no solution\n");
        return;
    }
    char output[cells + 1];
    memset(output, '.', cells);
    output[cells] = '\0';
    int count = 0;
    nb(cells, total_block_size, blocks, block_count, output, 0, &count);
}

int main() {
    int blocks1[] = {2, 1};
    nonoblock(5, blocks1, 2);
    printf("\n");

    nonoblock(5, NULL, 0);
    printf("\n");

    int blocks2[] = {8};
    nonoblock(10, blocks2, 1);
    printf("\n");

    int blocks3[] = {2, 3, 2, 3};
    nonoblock(15, blocks3, 4);
    printf("\n");

    int blocks4[] = {2, 3};
    nonoblock(5, blocks4, 2);

    return 0;
}
