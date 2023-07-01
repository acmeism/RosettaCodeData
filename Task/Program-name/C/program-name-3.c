/* myname.c */

#include <sys/param.h>
#include <sys/sysctl.h>	/* struct kinfo_proc */
#include <err.h>
#include <fcntl.h>	/* O_RDONLY */
#include <kvm.h>
#include <limits.h>	/* _POSIX2_LINE_MAX */
#include <stdio.h>

int
main(int argc, char **argv) {
	extern char *__progname;	/* from crt0.o */

	struct kinfo_proc *procs;
	kvm_t *kd;
	int cnt;
	char errbuf[_POSIX2_LINE_MAX];

	printf("argv[0]: %s\n", argv[0]);
	printf("__progname: %s\n", __progname);

	kd = kvm_openfiles(NULL, NULL, NULL, KVM_NO_FILES, errbuf);
	if (kd == NULL)
		errx(1, "%s", errbuf);
	procs = kvm_getprocs(kd, KERN_PROC_PID, getpid(),
	    sizeof procs[0], &cnt);
	if (procs == NULL)
		errx(1, "%s", kvm_geterr(kd));
	if (cnt != 1)
		errx(1, "impossible");

	printf("p_comm: %s\n", procs[0].p_comm);

	kvm_close(kd);
	return 0;
}
