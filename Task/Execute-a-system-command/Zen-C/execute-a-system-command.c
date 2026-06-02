import "std/sys/info.zc"
import "std/process.zc"

fn main() {
    let info = SysInfo::get_uname();
    let is_windows = strcmp(info.sysname.c_str(), "Windows") == 0;
    let cmd = is_windows ? "dir" : "ls";
    let exit_code = Command::new(cmd).status();
    if exit_code {
        println "Command failed with code {exit_code}";
    }
}
