#! /bin/sh

wims_home=`pwd`;
export tmp_dir=$wims_home/wimstest

export wims_exec_parm
$wims_home/other/bin/sigdigits 1.23 1.230 1.2300 1.23e5 1.23*10^5

$wims_home/other/bin/sigdigits 1.2300e5 .12340000 01.23*10^5 1.2.3.4

#shell : ./sigdigits "1.23" "1.230" "1.2300" "1.23e5" "1.23*10^5' "1.2300e5" ".12340000" "01.23*10^5" "1.2.3.4"
