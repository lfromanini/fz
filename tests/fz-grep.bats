#!/usr/bin/env bats

function setup()
{
	load "support/common.bash"
	export EDITOR=
}

@test "fz grep ................ # grep text" {

	setFzfMock grep "file.txt:1:text to search"
	run bash "${FZ_BIN}" grep "text to search"

	[[ ${status} == 0 ]]
	[[ $( cut -d: -f1 <<< "${output}" ) == file.txt ]]
}

@test "fz grep ................ # [ esc ] handles fzf cancellation" {

	setFzfMock grep
	run bash "${FZ_BIN}" grep

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz grep ................ # grep is unavailable" {

	function command()
	{
		[[ $1 == -v ]] && case $2 in
			rg|grep)
				printf "%s: command not found\n" "$2" >&2
				return 1
			;;
		esac

		builtin command "$@"
	}

	export -f command

	bats_require_minimum_version 1.5.0
	set +o errexit
	run -127 bash "${FZ_BIN}" grep

	[[ ${status} == 127 ]]
	[[ -z ${output} ]]
}
