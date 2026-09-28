#!/usr/bin/env bats

# shellcheck disable=SC2034     # SC2034: foo appears unused. Verify it or export it.

function setup() {
	load "support/common.bash"

	load "support/kill.bash"
	spawnTestProcess
}

function teardown() {
	kill "${TEST_PID}" &>/dev/null || true
}

@test "fz kill ................ # [ esc ] handles fzf cancellation" {

	mockFzfEscape
	run bash "${PATH_BIN}"/fz kill

	[[ "${status}" == 0 ]]
	[[ -z "${output}" ]]
}

@test "fz kill ................ # [ enter ] kill with default -SIGTERM" {

	FZF_MOCK_OUTPUT=FZF_MOCK_OUTPUT=$'enter\nuser '"${TEST_PID}"' 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz kill

	[[ "${status}" == 0 ]]
	[[ -z "${output}" ]]
}

@test "fz kill -SIGKILL ....... # [ enter ] kill with valid signal" {

	FZF_MOCK_OUTPUT=FZF_MOCK_OUTPUT=$'enter\nuser '"${TEST_PID}"' 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz kill -SIGKILL

	[[ "${status}" == 0 ]]
	[[ -z "${output}" ]]
}

@test "fz kill -9 ............. # [ enter ] kill with valid signal number" {
	FZF_MOCK_OUTPUT=FZF_MOCK_OUTPUT=$'enter\nuser '"${TEST_PID}"' 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz kill -9

	[[ "${status}" == 0 ]]
	[[ -z "${output}" ]]
}

@test "fz kill -NOT_A_SIGNAL .. # [ enter ] kill with invalid signal" {

	FZF_MOCK_OUTPUT=$'enter\nuser 12345 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz kill -NOT_A_SIGNAL

	[[ "${status}" == 1 ]]
	[[ -z "${output}" ]]
}

@test "fz kill --SIGTERM ...... # [ enter ] kill with invalid signal" {

	FZF_MOCK_OUTPUT=$'enter\nuser 12345 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz kill --SIGTERM

	[[ "${status}" == 1 ]]
	[[ -z "${output}" ]]
}

@test "fz kill 9 .............. # [ enter ] kill with invalid signal" {

	FZF_MOCK_OUTPUT=$'enter\nuser 12345 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz kill 9

	[[ "${status}" == 1 ]]
	[[ -z "${output}" ]]
}

@test "fz kill ................ # [ ctrl-k ] kill with -SIGKILL" {

	FZF_MOCK_OUTPUT=$'ctrl-k\nuser '"${TEST_PID}"' 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz kill

	[[ "${status}" == 0 ]]
	[[ -z "${output}" ]]
}
