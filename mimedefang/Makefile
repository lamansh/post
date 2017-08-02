SALEARN=HOME=/bayes && sudo -u mailnull /usr/local/bin/sa-learn --prefs-file=sa-mimedefang.cf
TRIMAWL=sudo -u mailnull ./trim-awl
HOSTNAME!=	hostname

restart: mimedefang_restart
	@ps ax | grep sendmail
	@tail -f /var/log/maillog

mimedefang_restart: zip mimedefang-startup clean_locks
	@/usr/local/etc/rc.d/mimedefang.sh start
	@sleep 14
	@cd /etc/mail && make start

clean_locks: stop
	@cd /bayes/.spamassassin && \
	LOCKS=`grep -l -s "${HOSTNAME}" *.lock*` || true && \
	for lock in $${LOCKS}; do \
		rm $$lock; \
	done

stop:
	@cd /etc/mail && make stop
	@/usr/local/etc/rc.d/mimedefang.sh stop wait || true
	@sleep 4

mimedefang-startup: /usr/local/etc/rc.d/mimedefang.sh

/usr/local/etc/rc.d/mimedefang.sh: /usr/local/etc/rc.d/mimedefang.sh-dist
	cd /usr/local/etc/rc.d && cp -p mimedefang.sh-dist mimedefang.sh


zip:	mimedefang.zip

sync:	bayes_sync

learn:	bayes_learn

stat:	bayes_stat

mimedefang.zip: *-filter *.cf mimedefang.conf Makefile trim-awl mimedefang.pl
	if [ -r mimedefang.zip ] ; then \
		mv mimedefang.zip mimedefang_old.zip ; \
	fi
	zip mimedefang.zip *-filter *.cf mimedefang.conf Makefile trim-awl mimedefang.pl

backup:	bayes_backup mimedefang.zip bayes_backup.zip

bayes_backup.zip: bayes_backup
	if [ -r bayes_backup.zip ] ; then \
		mv bayes_backup.zip bayes_backup_old.zip ; \
	fi
	zip -m bayes_backup.zip bayes_backup

recreate: bayes_backup bayes_restore bayes_backup.zip
	
bayes_backup: 
	${SALEARN} -D --backup >bayes_backup
	
bayes_restore: 	
	${SALEARN} --restore=bayes_backup

bayes_sync:	
	${SALEARN} --sync

bayes_stat:
	${SALEARN} --dump magic

bayes_learn:
	${SALEARN} --spam --mbox /home/${USER}/mail/Spam
	${SALEARN} --ham --mbox /home/${USER}/mail/NonSpam

sendru: zip
	cp mimedefang.zip /home/${USER}/sendru/

sendua: zip
	cp mimedefang.zip /home/${USER}/sendua/

expire:
	${TRIMAWL} /bayes/.spamassassin/auto-whitelist
	${SALEARN} -D --force-expire 

updateonly: 
	sftp -b sftp dpetrov@nch1.nchcapital.com 
	if [ -r sftp.new ] ; then \
		if [ "`cmp -z sftp sftp.new`" = "" ]; then \
			rm sftp.new; \
		else \
			mv sftp.new sftp; \
			make updateonly; \
		fi; \
	fi;

update: zip updateonly
	make afterupdate

afterupdate: restart 

unknown: other.new
	grep "Milter: to=<.*nchadvisors\.com>.*554.*User unknown" /var/log/maillog | sed -e 's/.*to=<\(.*\)>.*/\1/' | sort -u local-traps other.new - >local-traps.new
	rm other.new
	if [ "`cmp -z local-traps local-traps.new`" = "" ]; then \
		rm local-traps.new; \
	else \
		mv local-traps.new local-traps; \
		make mimedefang_restart; \
	fi; \

other:
	grep "Milter: data, reject=554 5.7.1 <.*@\(acorn\.ru\|dpetrov\.com\|megabus\.ru\)>.*we do not accept e-mails from spammers.*" /var/log/maillog | sed -e 's/.*<\(.*\)>.*/\1/' | sort -u >other

other.new:
	touch other.new
