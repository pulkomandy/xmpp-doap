#!/bin/sh
URL=http://localhost:8000/xep-0048.xml

if [ `uname` = Haiku ]
then
	open $URL
else
	# Other OS don't have such a command, so try to guess what tool to use to open http URLs.
	firefox $URL
fi
