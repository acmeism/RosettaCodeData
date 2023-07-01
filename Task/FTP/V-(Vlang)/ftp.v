import net.ftp

fn main() {
	result := ftp_client_test() or {println('Error: something went wrong') exit(1)}
	println(result)
}


fn ftp_client_test() ?[]u8 {
	mut zftp := ftp.new()
	mut blob := []u8{}	
	defer {
		zftp.close() or {
			println('Error: failure to close ftp')
			exit(10)
		}
	}
	connect_result := zftp.connect('ftp.redhat.com') or {
		println('Error: failed to connect')
		exit(1)
	}
	login_result := zftp.login('ftp', 'ftp') or {
		println('Error: failed to login')
		exit(2)
	}
	pwd := zftp.pwd() or {
		println('Error: failed to login')
		exit(3)
	}
	if (connect_result == true) && (login_result == true) && (pwd.len > 0) {
		zftp.cd('/') or {
			println('Error: failed to get root directory')
			exit(4)
		}
	}
	dir_list1 := zftp.dir() or {
		println('Error: failed to get directory listing')
		exit(5)
	}
	if dir_list1.len > 0 {
		zftp.cd('/suse/linux/enterprise/11Server/en/SAT-TOOLS/SRPMS/') or {
			println('Error: failed to get directory listing')
			exit(6)
		}
	}
	dir_list2 := zftp.dir() or {
		println('Error: failed to get directory listing')
		exit(7)
	}
	if dir_list2.len > 0 {
		if dir_list2.contains('katello-host-tools-3.3.5-8.sles11_4sat.src.rpm')	== true {
			blob = zftp.get('katello-host-tools-3.3.5-8.sles11_4sat.src.rpm') or {
				println('Error: failed to get directory listing')
				exit(8)
			}
		}
	}
	if blob.len <= 0 {
		println('Error: failed to get data')
		exit(9)
	}
	return blob
}
