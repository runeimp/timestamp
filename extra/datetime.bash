#!/usr/bin/env bash
###########
# datetime Convert a UNIX datetime to YY-MM-DD_HHMMSS
#
# @author   RuneImp <runeimp@gmail.com>
# @version  1.0.0
# @license  http://opensource.org/licenses/MIT
# @see      http://stackoverflow.com/questions/2371248/how-to-convert-timestamps-to-dates-in-bash
#
###
# Usage:
# ------
# datetime 1401228257
# -or-
# echo 1401228257 | datetime
# -or to get the current datetime-
# datetime
#
# To have datetime store the OS in your environment (for performance reasons)
# then run in the following manner at least once:
#
# exec datetime 1401228257
# -or-
# echo 1401228257 | exec datetime
# -or to simply initialize performance-
# exec datetime
#
###
# Installation
# ------------
# 1. datetime must be in your path and executable.
# 
###
# Error Codes:
# ------------
#  1 = WFT?
#
###
# ChangeLog:
# ----------
# 2018-05-15  v1.1.0      Now handles timestamp with micro time decimal
# 2015-09-23  v1.0.0      Script now handles piped input and works on Linux and Mac/BSD systems.
# 2014-05-27  v0.1.0      Initial script creation. Mac only
# 
###
# ToDo:
# -----
# [ ] ...
#

INT_RE='^([^0-9]*)([0-9]+)(\.[0-9]+)?(.*)$'

if [ -z "$OS_IS_MAC" ]; then
	OS_IS_MAC=`uname -s`
	if [ "$OS_IS_MAC" = 'Darwin' ]; then
		OS_IS_MAC=0
	else
		OS_IS_MAC=1
	fi
	export OS_IS_MAC
fi

if [ $# -eq 0 ]; then
	if [ -p /dev/stdin ]	# input from a pipe
	then
		read -r ref_time
	else
		ref_time=`date "+%s"`
	fi
else
	ref_time=$1
fi

if [[ $ref_time =~ $INT_RE ]]; then
	# echo ${BASH_REMATCH[@]}
	# echo ${BASH_REMATCH[1]}
	# i=0
	# while [[ $i -lt ${#BASH_REMATCH[@]} ]]; do
	# 	echo ${BASH_REMATCH[$i]}
	# 	let "i += 1"
	# done
	ref_time=${BASH_REMATCH[2]}
fi

if [[ ${#BASH_REMATCH[1]} -gt 0 ]]; then
	printf "${BASH_REMATCH[1]}"
fi
if [ $OS_IS_MAC -eq 0 ]; then
	date_str="$(date -r "$ref_time" "+%Y-%m-%d_%H%M%S")"
else
	date_str="$(date -d @"$ref_time" '+%Y-%m-%d_%H%M%S')"
fi
printf $date_str
if [[ ${#BASH_REMATCH[4]} -gt 0 ]]; then
	printf "${BASH_REMATCH[4]}"
fi
