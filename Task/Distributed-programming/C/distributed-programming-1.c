#include <stdio.h>
#include <stdlib.h>
#include <pvm3.h>

int main(int c, char **v)
{
	int tids[10];
	int parent, spawn;
	int i_data, i2;
	double f_data;

	if (c > 1) {
		spawn = pvm_spawn("/tmp/a.out", 0, PvmTaskDefault, 0, 1, tids);
		if (spawn <= 0) {
			printf("Can't spawn task\n");
			return 1;
		}

		printf("Spawning successful\n");

		/* pvm_recv(task_id, msgtag).  msgtag identifies what kind of data it is,
 		 * for here: 1 = (int, double), 2 = (int, int)
		 * The receiving order is intentionally swapped, just to show.
		 * task_id = -1 means "receive from any task"
		 */
		pvm_recv(-1, 2);
		pvm_unpackf("%d %d", &i_data, &i2);
		printf("got msg type 2: %d %d\n", i_data, i2);

		pvm_recv(-1, 1);
		pvm_unpackf("%d %lf", &i_data, &f_data);
		printf("got msg type 1: %d %f\n", i_data, f_data);
	} else {
		parent = pvm_parent();

		pvm_initsend(PvmDataDefault);
		i_data = rand();
		f_data = (double)rand() / RAND_MAX;
		pvm_packf("%d %lf", i_data, f_data);
		pvm_send(parent, 1);	/* send msg type 1 */

		pvm_initsend(PvmDataDefault);
		i2 = rand();
		pvm_packf("%d %d", i_data, i2);
		pvm_send(parent, 2);	/* send msg type 2 */
	}

	pvm_exit();
	return 0;
}
