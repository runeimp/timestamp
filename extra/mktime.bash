#!/usr/bin/env bash
###########
# mktime YY-MM-DD_HHMMSS
#
# @author   RuneImp <runeimp@gmail.com>
# @version  0.1.1
# @license  http://opensource.org/licenses/MIT
#
###
# show_usage:
# ------
# mktime
# mktime YY-MM-DD_HHMMSS
# 
###
# Installation
# ------------
# 1. mktime must be in your path and executable.
# 
###
# Error Codes:
# ------------
#  1 = WFT?
#
###
# ChangeLog:
# ----------
#	2014-03-08	v0.1.1	Updated ToDo list
#	2014-02-20	v0.1.0	Initial script creation
# 
###
# ToDo:
# -----
# [ ] Allow generating mktime with different timezones
# [ ] Allow generating mktime in UTC specifically (date -u)
# [ ] Converter a mktime to YY-MM-DD_HHMMSS format
# [ ] Add options to display usage and version
# [x] Set missing hours to 00
# [x] Set missing minutes to 00
# [x] Set missing seconds to 00
#

if [ $# -eq 0 ]; then
	date "+%s"
else
	ref_time=$1
	len=${#ref_time}
	# echo "\$len: $len"
	# echo "\$ref_time: $ref_time"
	if [ $len -eq 17 ]; then
		ref_time=$1
	elif [ $len -eq 10 ]; then
		ref_time="$1_000000"
	elif [ $len -gt 10 ]; then
		while [ ${#ref_time} -lt 17 ]
		do
			ref_time+='0'
		done
	else
		ref_time="$1"
	fi
	echo "\$ref_time: $ref_time" 1>&2
	date -j -f "%Y-%m-%d_%H%M%S" "$ref_time" "+%s"
fi