#!/usr/bin/env bats

# shellcheck disable=SC1091     # SC1091: Not following: (error message here)
# shellcheck disable=SC2034     # SC2034: foo appears unused. Verify it or export it.

function setup() {
	load "support/common.bash"
}

function teardown() { true ; }

@test "fz --help" {

	run bash "${PATH_BIN}"/fz --help

	[[ "${status}" == 0 ]]
	[[ "${output}" == *"Usage:"* ]]
}

@test "fz -h" {

	run bash "${PATH_BIN}"/fz -h

	[[ "${status}" == 0 ]]
	[[ "${output}" == *"Usage:"* ]]
}

@test "fz ..................... # no arguments provided" {

	run bash "${PATH_BIN}"/fz

	[[ "${status}" == 0 ]]
	[[ "${output}" == *"Usage:"* ]]
}

@test "fz --version" {

	source "${PATH_BIN}"/fz
	run bash "${PATH_BIN}"/fz --version

	[[ "${status}" == 0 ]]
	[[ "${output}" == "fz ${VERSION}" ]]
}

@test "fz -V" {

	source "${PATH_BIN}"/fz
	run bash "${PATH_BIN}"/fz -V

	[[ "${status}" == 0 ]]
	[[ "${output}" == "fz ${VERSION}" ]]
}

@test "fz ..................... # fzf not installed" {

	bats_require_minimum_version 1.5.0
	set +o errexit
	PATH="" run -127 bash "${PATH_BIN}"/fz

	[[ "${status}" == 1 ]]
	[[ "${output}" == "[fz error]:"* ]]
}

@test "fz unsupportedArgument" {

	run bash "${PATH_BIN}"/fz unsupportedArgument

	[[ "${status}" == 1 ]]
	[[ "${output}" == "[fz error]:"*"unsupportedArgument"* ]]
}
