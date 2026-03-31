#! /bin/sh

wims_home=`pwd`;
wims_dirtest="$wims_home/wimstest/dirtest";

$wims_home/src/OefMsg2wims/msg2wims $wims_dirtest/msg2wims $wims_home/wimstest/tmp/msg1

cat $wims_home/wimstest/tmp/msg1

perl -pi -e 's/ +\n/\n/' $wims_home/wimstest/tmp/msg1
cp -f $wims_home/wimstest/tmp/msg1 $wims_home/wimstest/tmp/msg2wims
