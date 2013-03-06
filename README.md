xbmc-tvheadend-autodeletewatched
================================

Script to run on a tvheadend server to automatically delete watched recordings from tvheadend store

================================
INSTALLATION:

To install, simply copy this script over to the machine that runs TVHeadend
Edit the script and set a few parameters first at the top of the file.

When happy set the TESTING parameter in the file to 0 this will then do deleting
(Before that it only displays what will happen, does not delete files!)

After setting TESTING=0 you can schedule this in cron so it runs daily, simplest
method is in ubuntu/debian do:
	ln -s autodelete.sh /etc/cron.daily/

Output of the script by default will be emailed to you when it runs by the cronjob system




REQUIRES:
	mysqldump (Only if you use MySQL as the database for XBMC)
	find
	sqlite3 (Only if you use the default SQLite in XBMC)
	[note, use sqlite3 not sqlite package in debian/ubuntu]

Revision History:

0.0.1	04/03/2013	Initial code
