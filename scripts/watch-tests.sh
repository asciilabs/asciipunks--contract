#! /bin/sh

set -oe

watchman watch .

watchman -j <<-EOT
["trigger", "$HOME/workspace/asciipunks", {
   "name": "solidity tests",
   "command": ["truffle", "test"],
   "append_files": false
}]
EOT

LOG_FILE=`ps aux | grep [w]atchman\/4 | sed "s/.*logfile=\([a-zA-Z/-]*\).*/\1/g"`

tail -f $LOG_FILE
