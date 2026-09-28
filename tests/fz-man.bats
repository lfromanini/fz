#!/usr/bin/env bats

# shellcheck disable=SC2034     # SC2034: foo appears unused. Verify it or export it.

function setup() {
	load "support/common.bash"
}

function teardown() { true ; }

@test "fz man" {

	FZF_MOCK_OUTPUT="ls (1)               - list directory contents"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz man

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-man 1 ls" ]]
}

@test "fz man ................. # [ esc ] handles fzf cancellation" {

	mockFzfEscape
	run bash "${PATH_BIN}"/fz man

	[[ "${status}" == 0 ]]
	[[ -z "${output}" ]]
}
