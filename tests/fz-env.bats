#!/usr/bin/env bats

# shellcheck disable=SC2034     # SC2034: foo appears unused. Verify it or export it.

function setup() {
	load "support/common.bash"

	load "support/env.bash"
}

function teardown() { true ; }

@test "fz env" {

	FZF_MOCK_OUTPUT="HOME=${HOME}"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz env

	[[ "${status}" == 0 ]]
	[[ "$( stripColors "${output}" )" == "HOME=${HOME}" ]]
}
