#!/usr/bin/env bats

# shellcheck disable=SC2034     # SC2034: foo appears unused. Verify it or export it.

function setup() {
	load "support/common.bash"
}

function teardown() { true ; }

@test "fz ssh" {

	FZF_MOCK_OUTPUT="myServer"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz ssh

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-ssh myServer" ]]
}
