#!/usr/bin/env bats

setup() {
	load "test_helper/common.bash"
}

teardown() { true ; }

@test "fz --help" {
	run bash "${FZ}" --help

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == *"Usage:"* ]]
}

@test "fz -h" {
	run bash "${FZ}" -h

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == *"Usage:"* ]]
}

@test "fz	# no arguments provided" {
	run bash "${FZ}"

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == *"Usage:"* ]]
}

@test "fz --version" {
	# shellcheck disable=SC1090     # SC1090: Can't follow non-constant source. Use a directive to specify location
	source "${FZ}"

	run bash "${FZ}" --version

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "fz ${VERSION}" ]]
}

@test "fz -V" {
	# shellcheck disable=SC1090     # SC1090: Can't follow non-constant source. Use a directive to specify location
	source "${FZ}"

	run bash "${FZ}" -V

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "fz ${VERSION}" ]]
}

@test "fz	# fzf not installed" {
	local cleanPath=""

	while IFS= read -r -d ":" dir ; do
		command -v "${dir}"/fzf &>/dev/null || cleanPath+="${dir}:"
	done <<< "${PATH}:"

	# shellcheck disable=SC2030     # SC2030: Modification of var is local (to subshell caused by pipeline).
	# shellcheck disable=SC2031     # SC2031: var was modified in a subshell. That change might be lost.
	local PATH="${cleanPath}"

	bats_require_minimum_version 1.5.0
	set +o errexit
	run -127 bash "${FZ}"

	[[ "${status}" -ne 0 ]]
	[[ "${output}" == "[fz error]:"* ]]
}

@test "fz unsupportedArgument" {

	run bash "${FZ}" unsupportedArgument

	[[ "${status}" -ne 0 ]]
	[[ "${output}" == "[fz error]:"*"unsupportedArgument"* ]]
}

@test "fz kill" {
	# shellcheck disable=SC2030     # SC2030: Modification of var is local (to subshell caused by pipeline).
	# shellcheck disable=SC2031     # SC2031: var was modified in a subshell. That change might be lost.
	local PATH="${PATH_MOCKS}:${PATH}"

	run bash "${FZ}" kill

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-kill -SIGTERM selectedItem" ]]
}

@test "fz kill -9" {
	# shellcheck disable=SC2030     # SC2030: Modification of var is local (to subshell caused by pipeline).
	# shellcheck disable=SC2031     # SC2031: var was modified in a subshell. That change might be lost.
	local PATH="${PATH_MOCKS}:${PATH}"

	run bash "${FZ}" kill -9

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-kill -9 selectedItem" ]]
}

@test "fz man" {
	# shellcheck disable=SC2030     # SC2030: Modification of var is local (to subshell caused by pipeline).
	# shellcheck disable=SC2031     # SC2031: var was modified in a subshell. That change might be lost.
	local PATH="${PATH_MOCKS}:${PATH}"

	run bash "${FZ}" man

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-man"* ]]
}

@test "fz ssh" {
	# shellcheck disable=SC2030     # SC2030: Modification of var is local (to subshell caused by pipeline).
	# shellcheck disable=SC2031     # SC2031: var was modified in a subshell. That change might be lost.
	local PATH="${PATH_MOCKS}:${PATH}"

	run bash "${FZ}" ssh

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-ssh"* ]]
}
