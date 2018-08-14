#!/bin/bash

die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}

begins_with_short_option()
{
	local first_option all_short_options
	all_short_options='h'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_extract="off"

print_help ()
{
	printf '%s\n' "This script download all datasets used in Detecting and Explaining Causes From Text For a Time Series Event, EMNLP'17: https://arxiv.org/abs/1707.08852."
	printf 'Usage: %s [--(no-)extract] [-h|--help]\n' "$0"
	printf '\t%s\n' "--extract,--no-extract: Extract the downloaded tarball data (off by default)"
	printf '\t%s\n' "-h,--help: Prints help"
}

parse_commandline ()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			--no-extract|--extract)
				_arg_extract="on"
				test "${1:0:5}" = "--no-" && _arg_extract="off"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"

wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" kinshasa.lti.cs.cmu.edu/data/cgraph/ -P ./data/

if [ "$_arg_extract" == "on" ]
then
	cd ./data
	cat *.tar.gz | tar -zxvf - -i
fi