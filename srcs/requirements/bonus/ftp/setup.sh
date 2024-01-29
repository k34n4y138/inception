#!/bin/sh

# script to setup ftp server


# disable anonymous login
sed -i 's/#\?anonymous_enable=[^#]*/anonymous_enable=NO/' /etc/vsftpd.conf

# enable local users to login
sed -i 's/#\?local_enable=[^#]*/local_enable=YES/' /etc/vsftpd.conf

# enable write access
sed -i 's/#\?write_enable=[^#]*/write_enable=YES/' /etc/vsftpd.conf

#chroot user to their home directory
sed -i 's/#\?chroot_local_user=[^#]*/chroot_local_user=YES/' /etc/vsftpd.conf

echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf

#disable passive mode
sed -i 's/#\?pasv_enable=[^#]*/pasv_enable=NO/' /etc/vsftpd.conf

mkdir -p /var/run/vsftpd/empty
