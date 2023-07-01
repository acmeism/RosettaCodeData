/* Four-way branch.
 *
 * if2 (firsttest, secondtest
 *			, bothtrue
 *			, firstrue
 *			, secondtrue
 *			, bothfalse
 *	)
 */
#define if2(firsttest,secondtest,bothtrue,firsttrue,secondtrue,bothfalse)\
	switch(((firsttest)?0:2)+((secondtest)?0:1)) {\
		case 0: bothtrue; break;\
		case 1: firsttrue; break;\
		case 2: secondtrue; break;\
		case 3: bothfalse; break;\
	}
