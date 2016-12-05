#!/usr/bin/lasso9

define getenv(sysvar::string) => {
	local(regexp = regexp(
		-find = `(?m)^` + #sysvar + `=(.*?)$`,
		-input = sys_environ -> join('\n'),
		-ignorecase
	))
	return #regexp ->find ? #regexp -> matchString(1)
}

stdoutnl(getenv('HOME'))
stdoutnl(getenv('PATH'))
stdoutnl(getenv('USER'))
stdoutnl(getenv('WHAT'))
