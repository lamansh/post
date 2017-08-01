#!/bin/sh 
/usr/sbin/pkg info > /tmp/pkg_info
BACKUPFILE=backup-postnew-$(date +%m-%d-%Y).tar.gz
tar Pcfz /tmp/back-to-general/back/$BACKUPFILE --exclude /var/imap/socket --exclude /root/.cpan /usr/local/lib/sasl2 /root /etc /usr/local/etc /var/imap /usr/local/www /usr/src/sys/i386/conf /tmp/pkg_info /var/db/ports /var/db/openldap-data  > /tmp/back-to-general/tar_log

/usr/local/bin/smbclient //192.168.0.60/BackupBSD -A /tmp/back-to-general/backupbsd -l /tmp/back-to-general -c "prompt; lcd /tmp/back-to-general/back recurse; mput *; exit;"
#cat /tmp/back-to-general/log.smbclient | mail -s "log post backup job" roman@nchadvisors.kiev.ua
echo "" > /tmp/back-to-general/log.smbclient
rm /tmp/back-to-general/back/* 
