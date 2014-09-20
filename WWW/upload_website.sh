#! /bin/bash

if [ $# == 0 ]; then
    user=`whoami`
else
    user=$1
fi

target=$user@cardinal.stanford.edu:/afs/ir/class/psych252/WWW

echo "Uploading to $target"

cp datasets/* _build/html/data/
cp tutorial_files/* _build/html/tutorials/
cp section_files/* _build/html/section/
rsync -azP _build/html/ $target
