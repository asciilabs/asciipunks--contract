#! /bin/sh

set -oe

watchman watch . --logfile /tmp/watchman-solidity-test.log

watchman -j <<-EOT
["trigger", ".", {
   "name": "solidity tests",
   "command": ["truffle", "test"],
   "append_files": false
}]
EOT

tail -f /tmp/watchman-solidity-test.log
