#!/bin/sh 
/usr/sbin/pkg_info > /tmp/pkg_info
BACKUPFILE=backup-postnew-$(date +%m-%d-%Y).tar.gz
tar Pcfz /tmp/back-to-general/back/$BACKUPFILE --exclude /var/imap/socket --exclude /root/.cpan /root /usr/local/lib/sasl2 /etc /usr/local/etc /var/imap /usr/local/www /var/named /usr/src/sys/i386/conf/MYKERNEL /tmp/pkg_info /var/db/ports /var/db/openldap-data /usr/local/www/phpldapadmin/htdocs/ldif /usr/local/www/phpldapadmin/htdocs/tree.php > /tmp/back-to-general/tar_log

/usr/local/bin/smbclient //192.168.0.60/BackupBSD -A /tmp/back-to-general/backupbsd -l /tmp/back-to-general -c "prompt; lcd /tmp/back-to-general/back recurse; mput *; exit;"
#cat /tmp/back-to-general/log.smbclient | mail -s "log postnew backup job" sharov@nchadvisors.kiev.ua
echo "" > /tmp/back-to-general/log.smbclient
rm /tmp/back-to-general/back/* 
