local(env_vars = sys_environ -> join('###'))
if(#env_vars >> regexp(`(LANG|LC_ALL|LC_CTYPE).*?UTF.*?###`)) => {
	stdout('UTF supported \u25b3')
else
	stdout('This terminal does not support UTF')
}
