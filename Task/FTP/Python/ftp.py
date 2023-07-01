from ftplib import FTP
ftp = FTP('kernel.org')
ftp.login()
ftp.cwd('/pub/linux/kernel')
ftp.set_pasv(True) # Default since Python 2.1
print ftp.retrlines('LIST')
print ftp.retrbinary('RETR README', open('README', 'wb').write)
ftp.quit()
