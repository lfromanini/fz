#!/usr/bin/env bats

# shellcheck disable=SC2034     # SC2034: foo appears unused. Verify it or export it.

function setup() {
	load "support/common.bash"
	export EDITOR=
}

function teardown() { true ; }

@test "fz grep" {

	FZF_MOCK_OUTPUT="file.txt:1:text to search"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz grep "text to search"

	[[ "${status}" == 0 ]]
	[[ "${output}" == "file.txt" ]]
}

@test "fz grep ................ # [ esc ] handles fzf cancellation" {

	mockFzfEscape
	run bash "${PATH_BIN}"/fz grep

	[[ "${status}" == 0 ]]
	[[ -z "${output}" ]]
}

@test "fz grep ................ # grep is unavailable" {

	bats_require_minimum_version 1.5.0
	set +o errexit
	PATH="" run -127 bash "${PATH_BIN}"/fz grep

	[[ "${status}" == 127 ]]
	[[ -z "${output}" ]]
}
