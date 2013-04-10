#include <cmCPluginAPI.h>
#include <stdio.h>
#include <stdlib.h>

static cmCAPI *api;

/*
 * Respond to DIV(quotient remainder numerator denominator).
 */
static int
initial_pass(void *info, void *mf, int argc, char *argv[])
{
	div_t answer;
	int count, i, j, n[2];
	char buf[512], c;

	if (argc != 4) {
		api->SetError(info, "Wrong number of arguments");
		return 0;  /* failure */
	}

	/* Parse numerator and denominator. */
	for(i = 2, j = 0; i < 4; i++, j++) {
		count = sscanf(argv[i], "%d%1s", &n[j], c);
		if (count != 1) {
			snprintf(buf, sizeof buf,
			    "Not an integer: %s", argv[i]);
			api->SetError(info, buf);
			return 0;  /* failure */
		}
	}

	/* Call div(). */
	if (n[1] == 0) {
		api->SetError(info, "Division by zero");
		return 0;  /* failure */
	}
	answer = div(n[0], n[1]);

	/* Set variables to answer. */
	snprintf(buf, sizeof buf, "%d", answer.quot);
	api->AddDefinition(mf, argv[0], buf);
	snprintf(buf, sizeof buf, "%d", answer.rem);
	api->AddDefinition(mf, argv[1], buf);

	return 1;  /* success */
}

CM_PLUGIN_EXPORT void
DIVInit(cmLoadedCommandInfo *info)
{
	info->Name = "DIV";
	info->InitialPass = initial_pass;
	api = info->CAPI;
}
