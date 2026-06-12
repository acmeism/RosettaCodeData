mkdir ~/jail
cd ~/jail;
chroot ~/jail;
setuid(9); # if 9 is the userid of a non-root user
rm /etc/hosts # actually points to ~/jail/etc/hosts
