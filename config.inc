##### XBMC autodelete.sh script configuration file


## Settings
TYPE="mysql";                   		# set to mysql or sqlite

## Mysql specific settings
MYSQL_HOST="localhost";         		# mysql: server ip or hostname
MYSQL_USER="root";              		# mysql: username
MYSQL_PASS="";	        		# mysql: password
MYSQL_DB="";                    		# mysql: db - If blank will calculate the newest

## Sqlite specific settings
SQDB_PATH="/home/xbmc/.xbmc"    		# Path to the .xbmc folder
SQDB_DB="";                     		# sqlite: DB filename - If blank will calculate the newest

PATH_TO_RECORDINGS="/media/storage2/tvheadend/RecordedTV/";    # Path to where TVH stores recordings
DAYS_TO_DELETE=7                		# Number of days to wait before deleting watched files

PATH_TO_TVHEADEND_CONFIG="/home/hts/.hts"	# TVHeadend config folder

TESTING=0;			## Set to 1 to DISABLE the delete function
				## for testing
				## Set to 0 and files will be deleted


## No changes below here
CONFIG=1;
