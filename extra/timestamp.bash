#!/bin/sh
###########
# timestamp YY-MM-DD_HHMMSS
#
# @author   RuneImp <runeimp@gmail.com>
# @version  1.0.0
# @license  http://opensource.org/licenses/MIT
#
###
# show_usage:
# ------
# timestamp
# timestamp YY-MM-DD_HHMMSS
# 
###
# Installation
# ------------
# 1. timestamp must be in your path and executable.
# 
###
# Error Codes:
# ------------
#  1 = WFT?
#
###
# ChangeLog:
# ----------
# 2015-09-30  v1.0.0      Script now handles piped input and works on Linux and Mac systems.
# 2014-03-08  v0.1.1      Updated ToDo list
# 2014-02-20  v0.1.0      Initial script creation
# 
###
# ToDo:
# -----
# [ ] Allow generating timestamp with different timezones
# [ ] Allow generating timestamp in UTC specifically (date -u)
# [ ] Converter a timestamp to YY-MM-DD_HHMMSS format
# [ ] Add options to display usage and version
# [x] Set missing hours to 00
# [x] Set missing minutes to 00
# [x] Set missing seconds to 00
#

if [ -z "$OS_IS_MAC" ]; then
	OS_IS_MAC=`uname -s`
	if [ "$OS_IS_MAC" = 'Darwin' ]; then
		OS_IS_MAC=0
	else
		OS_IS_MAC=1
	fi
	export OS_IS_MAC
fi

APP_NAME='timestamp'
APP_VERSION='1.0.0'
APP_LABEL="$APP_NAME v$APP_VERSION"

sed_pattern='s/\([0-9]\{4\}\)[^0-9]*\([0-9]\{2\}\)[^0-9]*\([0-9]\{2\}\)[^0-9]*\([0-9]\{2\}\)[^0-9]*\([0-9]\{2\}\)[^0-9]*\([0-9]\{2\}\)[ 	]*\(.*\)/\1-\2-\3 \4:\5:\6 \7/'
sed_pattern_7='s/\([0-9]\{4\}\)[^0-9]*\([0-9]\{2\}\)[^0-9]*\([0-9]\{2\}\)[^0-9]*\([0-9]\{2\}\)[^0-9]*\([0-9]\{2\}\)[^0-9]*\([0-9]\{2\}\)[ 	]*\(.*\)/\1-\2-\3 \4:\5:\6 \7/'
sed_pattern_6='s/\([0-9]\{4\}\)[^0-9]*\([0-9]\{2\}\)[^0-9]*\([0-9]\{2\}\)[^0-9]*\([0-9]\{2\}\)[^0-9]*\([0-9]\{2\}\)[^0-9]*\([0-9]\{2\}\)[ 	]*\(.*\)/\1-\2-\3 \4:\5:\6/'
format=''
len=0
options=''
ref_time=''
zulu=1


show_help()
{
	cat <<-HELP
	$APP_LABEL

	SYNOPSIS
	    $APP_NAME [OPTIONS] YYYY-MM-DD_hhmmss

	DESCRIPTION
	    The $APP_NAME script will take datetime input specifying either a date only
	    (YYYY-MM-DD), date and time (YYYY-MM-DD_hhmmss) or something in between
	    (YYYY-MM-DD_hh, YYYY-MM-DD_hhmm, YYYY-MM-DD_hhm, etc.)
HELP
}

#
# Test for piped input
#
if [ -p /dev/stdin ]; then
	read -r ref_time
fi

#
# Parse options
#
until [ $# -eq 0 ]; do
	case "$1" in
		-g | -u | -z | --[Gg][Mm][Tt] | --[Uu][Tt][Cc] | -[Zz])
			# Greenwich Mean Time, Coordinated Universal Time, or Zulu Time
			zulu=0
			;;
		-h | --help)
			# Show help
			show_help
			exit 0
			;;
		-V | --version-number)
			# Show version number (only the number)
			printf "%s" "$APP_VERSION"
			exit 0
			;;
		-v | --version)
			# Show app version number
			echo "$APP_LABEL"
			exit 0
			;;
		[0-9][0-9][0-9][0-9]?[0-9][0-9]?[0-9][0-9]?[0-9][0-9]?[0-9][0-9]?[0-9][0-9]*)
			# Date to parse
			ref_time=`echo "$1" | sed "$sed_pattern"`
			;;
		[0-9][0-9][0-9][0-9]?[0-9][0-9]?[0-9][0-9]*)
			# Date to parse
			ref_time=`echo "$1" | sed "$sed_pattern"`
			;;
		[0-9]*)
			# Date to parse
			echo "ERROR -- You must provide at least a full date reference. Preferably in " 1>&2
			echo "         YYYY-MM-DD format. '$1' is not acceptable." 1>&2
			exit 1
			;;
		*)
			# Unknown option
			echo "ERROR -- Unknown option: '$1'" 1>&2
			exit 2
			;;
	esac

	shift
done
# echo "Option \$ref_time: $ref_time" 1>&2
# exit 69


if [ -z "$ref_time" ]; then
	if [ $OS_IS_MAC -eq 0 ]; then
		date -j '+%s'
	else
		date '+%s'
	fi
else
	len=${#ref_time}

	if [ $len -eq 10 ]; then
		format='%Y-%m-%d'
	elif [ $len -gt 10 ]; then
		format="%Y-%m-%d_%H%M%S"
		while [ ${#ref_time} -lt 17 ]; do
			ref_time="${ref_time}0"
		done
	fi
	echo "\$ref_time: $ref_time" 1>&2

	if [ $OS_IS_MAC -eq 0 ]; then
		if [ $zulu -eq 0 ]; then
			date -ju -f "$format" "$ref_time" '+%s'
		else
			date -j -f "$format" "$ref_time" '+%s'
		fi
	else
		if [ $zulu -eq 0 ]; then
			date -u +%s --date="$ref_time"
		else
			date +%s --date="$ref_time"
		fi
	fi
fi
