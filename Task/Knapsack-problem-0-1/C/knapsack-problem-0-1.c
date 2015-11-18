#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef struct {
        const char * name;
        int weight, value;
} item_t;

item_t item[] = {
        {"map",                     9,       150},
        {"compass",                 13,      35},
        {"water",                   153,     200},
        {"sandwich",                50,      160},
        {"glucose",                 15,      60},
        {"tin",                     68,      45},
        {"banana",                  27,      60},
        {"apple",                   39,      40},
        {"cheese",                  23,      30},
        {"beer",                    52,      10},
        {"suntancream",             11,      70},
        {"camera",                  32,      30},
        {"T-shirt",                 24,      15},
        {"trousers",                48,      10},
        {"umbrella",                73,      40},
        {"waterproof trousers",     42,      70},
        {"waterproof overclothes",  43,      75},
        {"note-case",               22,      80},
        {"sunglasses",              7,       20},
        {"towel",                   18,      12},
        {"socks",                   4,       50},
        {"book",                    30,      10}
};

#define n_items (sizeof(item)/sizeof(item_t))

typedef struct {
        uint32_t bits; /* 32 bits, can solve up to 32 items */
        int value;
} solution;


void optimal(int weight, int idx, solution *s)
{
        function solve(itemArray, capacity){
	matrix = create2DMatrix(itemArray.length, capacity);
	keep_matrix = create2DMatrix(itemArray.length, capacity);
	for(var c=0; c <= capacity; c++){
		matrix[0][c] = 0;
		keep_matrix[0][c] = 0;
	}
	for(var r=1; r<itemArray.length+1; ++r){//rows
			for(var c=0; c<=capacity; ++c){
				var toMatrix = 0;
				//fit in itself?
				var fit = items[r-1].weight<= c;
				if(fit){//add remaining mini-knapsack if any, and compare to not putting it
					var restCap = c-items[r-1].weight;
					toMatrix = items[r-1].value+ matrix[r-1][restCap];
					if( toMatrix > matrix[r-1][c])
						keep_matrix[r][c] = 1;
					else
						keep_matrix[r][c] = 0;
					toMatrix = Math.max(toMatrix, matrix[r-1][c]);
				}else{//copy the knapsack from row above
					toMatrix = matrix[r-1][c];
					keep_matrix[r][c] = 0;
				}				
				matrix[r][c] = toMatrix;
			}
		}		
	return matrix; 	
}

}

int main(void)
{
        int i = 0, w = 0;
        solution s = {0, 0};
        optimal(400, n_items - 1, &s);

        for (i = 0; i < n_items; i++) {
                if (s.bits & (1 << i)) {
                        printf("%s\n", item[i].name);
                        w += item[i].weight;
                }
        }
        printf("Total value: %d; weight: %d\n", s.value, w);
        return 0;
}
