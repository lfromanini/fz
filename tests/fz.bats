#!/usr/bin/env bats

function setup() { load "support/common.bash" ; }

@test "fz --help" {

	run bash "${FZ_BIN}" --help

	[[ ${status} == 0 ]]
	[[ ${output} == *"Usage:"* ]]
}

@test "fz -h" {

	run bash "${FZ_BIN}" -h

	[[ ${status} == 0 ]]
	[[ ${output} == *"Usage:"* ]]
}

@test "fz --version" {

	local version=
	version=$( awk -F= '/^readonly VERSION=/ { print $2 }' "${FZ_BIN}" )

	run bash "${FZ_BIN}" --version

	[[ ${status} == 0 ]]
	[[ ${output} == "fz ${version}" ]]
}

@test "fz -V" {

	local version=
	version=$( awk -F= '/^readonly VERSION=/ { print $2 }' "${FZ_BIN}" )

	run bash "${FZ_BIN}" -V

	[[ ${status} == 0 ]]
	[[ ${output} == "fz ${version}" ]]
}

@test "fz ..................... # fzf not installed" {

	function command()
	{
		[[ $1 == -v ]] && case $2 in
			fzf)
				printf "%s: command not found\n" "$2" >&2
				return 1
			;;
		esac

		builtin command "$@"
	}

	export -f command

	setFzfMock

	bats_require_minimum_version 1.5.0
	set +o errexit
	run -127 bash "${FZ_BIN}"

	[[ ${status} == 127 ]]
	[[ ${output} == "[fz error]:"* ]]
}

@test "fz _fz::completion kill  # valid non-public (internal) function call" {

	run bash "${FZ_BIN}" _fz:core::completion kill

	[[ ${status} == 0 ]]
	[[ ${output} == "SIG"* ]]
}

@test "fz _fz::unknownFunction  # unknown non-public (internal) function call" {

	bats_require_minimum_version 1.5.0
	set +o errexit
	run bash -127 "${FZ_BIN}" _fz::unknownFunction

	[[ ${status} == 127 ]]
	[[ ${output} == *"_fz::unknownFunction: command not found" ]]
}

@test "fz completions ......... # all commands are included" {

	setFzfMock

	# shellcheck disable=SC1090     # SC1090: Can't follow non-constant source. Use a directive to specify location
	source "${FZ_BIN}"

	local command=
	local bashCompletion=
	local zshCompletion=

	bashCompletion=$( bash "${FZ_BIN}" --bash-completion )
	zshCompletion=$( bash "${FZ_BIN}" --zsh-completion )

	while IFS= read -r command ; do
		[[ ${bashCompletion} == *"${command}"* ]]
		[[ ${zshCompletion} == *"${command}"* ]]
	done < <( __fz:core::commands )
}

@test "fz --bash-completion ... # valid bash completion" {

	run bash -c 'source <( "'"${FZ_BIN}"'" --bash-completion ) ; complete -p fz'
	[[ ${status} == 0 ]]
}

@test "fz --zsh-completion .... # valid zsh completion" {

	run zsh -c 'source <( "'"${FZ_BIN}"'" --zsh-completion ) ; whence -f _fz'
	[[ ${status} == 0 ]]
}
