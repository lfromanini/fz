#!/usr/bin/env bats

function setup() { load "support/common.bash" ; }

@test "fz --help ...................... # help (long argument)" {

	run bash "${FZ_BIN}" --help

	[[ ${status} == 0 ]]
	[[ ${output} == *"Usage:"* ]]
}

@test "fz -h .......................... # help (short argument)" {

	run bash "${FZ_BIN}" -h

	[[ ${status} == 0 ]]
	[[ ${output} == *"Usage:"* ]]
}

@test "fz --version ................... # version (long argument)" {

	local version=
	version=$( awk -F= '/^readonly VERSION=/ { print $2 }' "${FZ_BIN}" )

	run bash "${FZ_BIN}" --version

	[[ ${status} == 0 ]]
	[[ ${output} == "fz ${version}" ]]
}

@test "fz -V .......................... # version (short argument)" {

	local version=
	version=$( awk -F= '/^readonly VERSION=/ { print $2 }' "${FZ_BIN}" )

	run bash "${FZ_BIN}" -V

	[[ ${status} == 0 ]]
	[[ ${output} == "fz ${version}" ]]
}

@test "fz ............................. # valid requirements" {

	setFzfMock
	run bash "${FZ_BIN}"

	[[ ${status} == 0 ]]
}

@test "source fz ...................... # Bash version below minimum" {

	run bash -c '
		source "${FZ_BIN}"
		fz:core::check::gte "4.2.99" "4.3"
	'

	[[ ${status} == 1 ]]
}

@test "source fz ...................... # Bash 4.3 minimum" {

	run bash -c '
		source "${FZ_BIN}"
		fz:core::check::gte "4.3.0" "4.3"
	'

	[[ ${status} == 0 ]]
}

@test "source fz ...................... # Bash 5.3 release suffix" {

	run bash -c '
		source "${FZ_BIN}"
		fz:core::check::gte "5.3.20(1)-release" "4.3"
	'

	[[ ${status} == 0 ]]
}

@test "fz ............................. # fzf version below minimum" {

	FZF_MOCK_VERSION="0.59.9 (0.59.9)"
	setFzfMock
	run bash "${FZ_BIN}"

	[[ ${status} == 1 ]]
	[[ $( stripColors "${output}" ) == *"fzf 0.60 or newer is required"* ]]
}

@test "fz ............................ # invalid fzf version" {

	FZF_MOCK_VERSION="invalid"
	setFzfMock
	run bash "${FZ_BIN}"

	[[ ${status} == 2 ]]
	[[ $( stripColors "${output}" ) == *"fzf 0.60 or newer is required"* ]]
}

@test "fz ............................ # fzf with patch version" {

	# shellcheck disable=SC2034     # SC2034: foo appears unused. Verify it or export it.
	FZF_MOCK_VERSION="0.60.3 (0.60.3)"
	setFzfMock
	run bash "${FZ_BIN}"

	[[ ${status} == 0 ]]
}

@test "fz ............................. # fzf not installed" {

	function command()
	{
		[[ $1 == -v && $2 == fzf ]] && {
			printf "%s: command not found\n" "$2" >&2
			return 1
		}

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

@test "fz public:fz::completion kill .. # valid public function call" {

	run bash "${FZ_BIN}" public:fz:core::completion kill

	[[ ${status} == 0 ]]
	[[ ${output} == "SIG"* ]]
}

@test "fz public:fz::unknownFunction .. # unknown public function call" {

	bats_require_minimum_version 1.5.0
	set +o errexit
	run bash -127 "${FZ_BIN}" public:fz::unknownFunction

	[[ ${status} == 127 ]]
	[[ ${output} == *"public:fz::unknownFunction: command not found" ]]
}

@test "fz completions ................. # all commands are included" {

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

@test "fz --bash-completion ........... # valid bash completion" {

	run bash -c 'source <( "'"${FZ_BIN}"'" --bash-completion ) ; complete -p fz'
	[[ ${status} == 0 ]]
}

@test "fz --zsh-completion ............ # valid zsh completion" {

	run zsh -c 'source <( "'"${FZ_BIN}"'" --zsh-completion ) ; whence -f _fz'
	[[ ${status} == 0 ]]
}
