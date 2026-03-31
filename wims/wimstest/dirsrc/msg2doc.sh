#! /bin/sh

wims_home=`pwd`;
wims_dirtest="$wims_home/wimstest/dirtest";
w_msg2wims_primitives=`grep msgprim $wims_home/public_html/scripts/primitives/allmsgprim | awk -F "=" '{print $2}'`

export w_msg2wims_primitives

$wims_home/src/OefMsg2wims/msg2wims $wims_dirtest/msg2doc $wims_home/wimstest/tmp/msg1

perl -pi -e 's/ +\n/\n/' $wims_home/wimstest/tmp/msg1
cp -f $wims_home/wimstest/tmp/msg1 $wims_home/wimstest/tmp/msg2doc
