/**@file  HybridIDA.c
 * @brief solve 4x4 sliding puzzle with IDA* algorithm
 * by RMM 2021-feb-22

 * The Interative Deepening A* is relatively easy to code in 'C' since
 * it does not need Queues and Lists to manage memory. Instead the
 * search space state is held on the LIFO stack frame of recursive
 * search function calls. Millions of nodes may be created but they
 * are automatically deleted during backtracking.

 * Run-time is a disadvantage with complex puzzles. Also it struggles
 * to solve puzzles with depth g>50. I provided a test puzzle of g=52
 * that works with ordinary search but the Rosetta challenge puzzle
 * cycles forever. The HybridIDA solves it in 18 seconds.

 * The HybridIDA solution has two phases.
 * 1. It stops searching when a permutation begins with 1234.
 * 2. Phase2 begins a regular search with the output of phase 1.

 * (But an regular one time search can be done with phase 2
 * only). Phase 1 is optional.)

 * Pros: Hybrid IDA* is faster and solves more puzzles.
 * Cons: May not find shortest path.
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

typedef unsigned char u8t;
typedef unsigned short u16t;
enum { NR=4, NC=4, NCELLS = NR*NC };
enum { UP, DOWN, LEFT, RIGHT, NDIRS };
enum { OK = 1<<8, XX = 1<<9, FOUND = 1<<10, zz=0x80 };
enum { MAX_INT=0x7E, MAX_NODES=(16*65536)*90};
enum { BIT_HDR=1<<0, BIT_GRID=1<<1, BIT_OTHER=1<<2 };
enum { PHASE1,PHASE2 };  // solution phase

typedef struct { u16t dn; u16t hn; }HSORT_T;

typedef struct {
   u8t data[NCELLS]; unsigned id; unsigned src;
   u8t h; u8t g; u8t udlr;
}NODE_T;  // contains puzzle data and metadata

NODE_T goal44={
   {1,2,3,4, 5,6,7,8, 9,10,11,12, 13,14,15,0},0,0,0,0,0};
NODE_T work; // copy of puzzle with run-time changes

NODE_T G34={ //g=34; n=248,055; (1phase)
 {13,9,5,4, 15,6,1,8, 0,10,2,11, 14,3,7,12},0,0,0,0,0};

NODE_T G52={ // g=52; n=34,296,567; (1phase)
   {15,13,9,5, 14,6,1,4,  10,12,0,8, 3,7,11,2},0,0,0,0,0};

NODE_T G99={ // formidable Rosetta challenge (2phases)
   {15,14,1,6, 9,11,4,12, 0,10,7,3, 13,8,5,2},0,0,0,0,0};

struct {
   unsigned nodes;
   unsigned gfound;
   unsigned root_visits;
   unsigned verbose;
   unsigned locks;
   unsigned phase;
}my;

u16t  HybridIDA_star(NODE_T *pNode);
u16t  make_node(NODE_T *pNode, NODE_T *pNew, u8t udlr );
u16t  search(NODE_T *pNode, u16t bound);
u16t  taxi_dist( NODE_T *pNode);
u16t  tile_home( NODE_T *p44);
void  print_node( NODE_T *pN, const char *pMsg, short force );
u16t  goal_found(NODE_T *pNode);
char  udlr_to_char( char udlr );
void  idx_to_rc( u16t idx, u16t *row, u16t *col );
void  sort_nodes(HSORT_T *p);

int main( )
{
   my.verbose = 0;		// minimal print node
   // my.verbose |= BIT_HDR;	// node header
   // my.verbose |= BIT_GRID;	// node 4x4 data

   memcpy(&work,  &G99, sizeof(NODE_T));  // select puzzle here
   if(1){   // phase1 can skipped for easy puzzles
      printf("Phase1: IDA* search for 1234 permutation..\n");
      my.phase = PHASE1;
      (void) HybridIDA_star(&work);
   }
   printf("Phase2: IDA* search phase1 seed..\n");
   my.phase = PHASE2;
   (void)HybridIDA_star(&work);
   return 0;
}

/// \brief driver for Iterative Deepining A*
u16t HybridIDA_star(NODE_T *pN){
   my.nodes = 1;
   my.gfound = 0;
   my.root_visits = 0;
   pN->udlr = NDIRS;
   pN->g = 0;
   pN->h = taxi_dist(pN);
   pN->id = my.nodes;
   pN->src = 0;
   const char *pr = {"Start"}; // for g++
   print_node( pN,pr,1 );
   u16t depth = pN->h;
   while(1){
      depth = search(pN,depth);
      if( depth & FOUND){
         return FOUND;  // goodbye
      }
      if( depth & 0xFF00 ){
	 printf("..error %x\n",depth);
	 return XX;
      }
      my.root_visits++;
      printf("[root visits: %u, depth %u]\n",my.root_visits,depth);
   }
   return 0;
}

/// \brief search is recursive. nodes are instance variables
u16t search(NODE_T *pN, u16t bound){
   if(bound & 0xff00){ return bound; }
   u16t f = pN->g + pN->h;
   if( f > bound){ return f; }
   if(goal_found(pN)){
      my.gfound = pN->g;
      memcpy(&work,pN,sizeof(NODE_T));
      printf("total nodes=%d, g=%u \n", my.nodes, my.gfound);
      const char *pr = {"Found.."}; // for g++
      print_node( &work,pr,1 );
      return FOUND;
   }
   NODE_T news;
   // Sort successor nodes so that the lowest heuristic is visited
   // before the less promising at the same level. This reduces the
   // number of searches and finds more solutions
   HSORT_T hlist[NDIRS];
   for( short i=0; i<NDIRS; i++ ){
      u16t rv = make_node(pN,&news, i );
      hlist[i].dn = i;
      if( rv & OK ){
	 hlist[i].hn = news.h;
	 continue;
      }
      hlist[i].hn = XX;
   }
   sort_nodes(&hlist[0]);

   u16t temp, min = MAX_INT;
   for( short i=0; i<NDIRS; i++ ){
      if( hlist[i].hn > 0xff ) continue;
      temp = make_node(pN,&news, hlist[i].dn );
      if( temp & XX ) return XX;
      if( temp & OK ){
	 news.id = my.nodes++;
	 print_node(&news," succ",0 );
	 temp = search(&news, bound);
	 if(temp & 0xff00){  return temp;}
	 if(temp < min){ min = temp; }
      }
   }
   return min;
}

/// \brief sort nodes to prioitize heuristic low
void sort_nodes(HSORT_T *p){
   for( short s=0; s<NDIRS-1; s++ ){
      HSORT_T tmp = p[0];
      if( p[1].hn < p[0].hn ){tmp=p[0]; p[0]=p[1]; p[1]=tmp; }
      if( p[2].hn < p[1].hn ){tmp=p[1]; p[1]=p[2]; p[2]=tmp; }
      if( p[3].hn < p[2].hn ){tmp=p[2]; p[2]=p[3]; p[3]=tmp; }
   }
}

/// \brief return index of blank tile
u16t tile_home(NODE_T *pN ){
   for( short i=0; i<NCELLS; i++ ){
      if( pN->data[i] == 0 ) return i;
   }
   return XX;
}

/// \brief print node (or not) depending upon flags
void print_node( NODE_T *pN, const char *pMsg, short force ){
   const int tp1 = 0;
   if( my.verbose & BIT_HDR || force || tp1){
      char ch = udlr_to_char(pN->udlr);
      printf("id:%u src:%u; h=%d, g=%u, udlr=%c, %s\n",
	     pN->id, pN->src, pN->h, pN->g, ch, pMsg);
   }
   if(my.verbose & BIT_GRID || force || tp1){
      for(u16t i=0; i<NR; i++ ){
	 for( u16t j=0; j<NC; j++ ){
	    printf("%3d",pN->data[i*NR+j]);
	 }
	 printf("\n");
      }
      printf("\n");
   }
   //putchar('>');  getchar();
}

/// \brief return true if selected tiles are settled
u16t goal_found(NODE_T *pN) {
   if(my.phase==PHASE1){
      short tags = 0;
      for( short i=0; i<(NC); i++ ){
	 if( pN->data[i] == i+1 ) tags++;
      }
      if( tags==4 ) return 1;  // Permutation starts with 1234
   }

   for( short i=0; i<(NR*NC); i++ ){
      if( pN->data[i] != goal44.data[i] ) return 0;
   }
   return 1;
}

/// \brief convert UDLR index to printable char
char udlr_to_char( char udlr ){
   char ch = '?';
   switch(udlr){
   case UP:    ch = 'U'; break;
   case DOWN:  ch = 'D'; break;
   case LEFT:  ch = 'L'; break;
   case RIGHT: ch = 'R'; break;
   default: break;
   }
   return ch;
}

/// \brief convert 1-D array index to 2-D row-column
void idx_to_rc( u16t idx, u16t *row, u16t *col ){
   *row = idx/NR; *col = abs( idx - (*row * NR));
}

/// \brief make successor node with blank tile moved UDRL
/// \return success or error
u16t make_node(NODE_T *pSrc, NODE_T *pNew, u8t udlr ){
   u16t row,col,home_idx,idx2;
   if(udlr>=NDIRS||udlr<0 ){ printf("invalid udlr %u\n",udlr); return XX; }
   if(my.nodes > MAX_NODES ){ printf("excessive nodes %u\n",my.nodes);
      return XX; }
   memcpy(pNew,pSrc,sizeof(NODE_T));
   home_idx = tile_home(pNew);
   idx_to_rc(home_idx, &row, &col );

   if( udlr == LEFT)  { if( col < 1 ) return 0; col--; }
   if( udlr == RIGHT ){ if( col >= (NC-1) ) return 0; col++; }
   if( udlr == DOWN ) { if(row >= (NR-1)) return 0; row++; }
   if( udlr == UP ){	 if(row < 1) return 0; row--; }
   idx2 = row * NR + col;
   if( idx2 < NCELLS ){
      u8t *p = &pNew->data[0];
      p[home_idx] = p[idx2];
      p[idx2]     = 0; // swap
      pNew->src   = pSrc->id;
      pNew->g     = pSrc->g + 1;
      pNew->h     = taxi_dist(pNew);
      pNew->udlr  = udlr; // latest move;
      return OK;
   }
   return 0;
}

/// \brief sum of 'manhattan taxi' distance between tile locations
u16t taxi_dist( NODE_T *pN){
   u16t tile,sum = 0, r1,c1,r2,c2;
   u8t *p44 = &pN->data[0];
   for( short i=0; i<(NR*NC); i++ ){
      tile = p44[i];
      if( tile==0 ) continue;
      idx_to_rc(i, &r2, &c2 );
      idx_to_rc(tile-1, &r1, &c1 );
      sum += abs(r1-r2) + abs(c1-c2);
   }
   }
   return sum;
}
