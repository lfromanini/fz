#!/usr/bin/env bats

# shellcheck disable=SC2034     # SC2034: foo appears unused. Verify it or export it.

function setup() {
	load "support/common.bash"

	export TMUX=""
}

function teardown() { true ; }

@test "fz tmux ................ # tmux not installed" {

	bats_require_minimum_version 1.5.0
	set +o errexit
	PATH="" run -127 bash "${PATH_BIN}"/fz tmux

	[[ "${status}" == 1 ]]
	[[ "${output}" == "[fz error]:"*"tmux"* ]]
}

@test "fz tmux ................ # empty selection" {

	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz tmux

	[[ "${status}" == 0 ]]
	[[ -z "${output}" ]]
}

@test "fz tmux ................ # [ enter ] session inside tmux" {

	FZF_MOCK_OUTPUT=$'enter\nsession mySession _ 2w'
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux switch-client -t mySession" ]]
}

@test "fz tmux ................ # [ enter ] session outside tmux" {

	FZF_MOCK_OUTPUT=$'enter\nsession mySession _ 2w'

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux attach -t mySession" ]]
}

@test "fz tmux ................ # [ enter ] window inside tmux" {

	FZF_MOCK_OUTPUT=$'enter\nwindow mySession:0 bash 1p'
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux select-window -t mySession:0" ]]
}

@test "fz tmux ................ # [ enter ] window outside tmux" {

	FZF_MOCK_OUTPUT=$'enter\nwindow mySession:0 bash 1p'

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux attach -t mySession ; select-window -t mySession:0" ]]
}

@test "fz tmux ................ # [ enter ] pane inside tmux" {

	FZF_MOCK_OUTPUT=$'enter\npane mySession:0.1 bash'
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux select-window -t mySession:0.1 ; select-pane -t mySession:0.1" ]]
}

@test "fz tmux ................ # [ enter ] pane outside tmux" {

	FZF_MOCK_OUTPUT=$'enter\npane mySession:0.1 bash'

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux attach -t mySession ; select-pane -t mySession:0.1" ]]
}

@test "fz tmux ................ # [ ctrl-k ] session" {

	FZF_MOCK_OUTPUT=$'ctrl-k\nsession mySession _ 2w'
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux kill-session -t mySession" ]]
}

@test "fz tmux ................ # [ ctrl-k ] window" {

	FZF_MOCK_OUTPUT=$'ctrl-k\nwindow mySession:0 bash 1p'
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux kill-window -t mySession:0" ]]
}

@test "fz tmux ................ # [ ctrl-k ] pane" {

	FZF_MOCK_OUTPUT=$'ctrl-k\npane mySession:0.1 bash'
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux kill-pane -t mySession:0.1" ]]
}
