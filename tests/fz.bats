#!/usr/bin/env bats

# shellcheck disable=SC1090     # SC1090: Can't follow non-constant source. Use a directive to specify location
# shellcheck disable=SC2030     # SC2030: Modification of var is local (to subshell caused by pipeline).
# shellcheck disable=SC2031     # SC2031: var was modified in a subshell. That change might be lost.
# shellcheck disable=SC2034     # SC2034: foo appears unused. Verify it or export it.

function setup() {
	load "test_helper/common.bash"
}

function teardown() { true ; }

@test "fz --help" {
	run bash "${BIN_FZ}" --help

	[[ "${status}" == 0 ]]
	[[ "${output}" == *"Usage:"* ]]
}

@test "fz -h" {
	run bash "${BIN_FZ}" -h

	[[ "${status}" == 0 ]]
	[[ "${output}" == *"Usage:"* ]]
}

@test "fz       # no arguments provided" {
	run bash "${BIN_FZ}"

	[[ "${status}" == 0 ]]
	[[ "${output}" == *"Usage:"* ]]
}

@test "fz --version" {
	source "${BIN_FZ}"
	run bash "${BIN_FZ}" --version

	[[ "${status}" == 0 ]]
	[[ "${output}" == "fz ${VERSION}" ]]
}

@test "fz -V" {
	source "${BIN_FZ}"
	run bash "${BIN_FZ}" -V

	[[ "${status}" == 0 ]]
	[[ "${output}" == "fz ${VERSION}" ]]
}

@test "fz       # fzf not installed" {
	bats_require_minimum_version 1.5.0
	set +o errexit
	PATH="" run -127 bash "${BIN_FZ}"

	[[ "${status}" != 0 ]]
	[[ "${output}" == "[fz error]:"* ]]
}

@test "fz unsupportedArgument" {
	run bash "${BIN_FZ}" unsupportedArgument

	[[ "${status}" != 0 ]]
	[[ "${output}" == "[fz error]:"*"unsupportedArgument"* ]]
}

@test "fz env" {
	function stripColors() { printf "%s" "${*}" | sed $'s/\033\\[[0-9;]*m//g' ; }

	FZF_MOCK_OUTPUT="HOME=${HOME}"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" env

	[[ "${status}" == 0 ]]
	[[ "$( stripColors "${output}" )" == "HOME=${HOME}" ]]
}

@test "fz kill" {
	FZF_MOCK_OUTPUT="user 12345 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" kill

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-kill -SIGTERM 12345" ]]
}

@test "fz kill -9" {
	FZF_MOCK_OUTPUT="user 12345 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" kill -9

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-kill -9 12345" ]]
}

@test "fz man" {
	FZF_MOCK_OUTPUT="ls (1)               - list directory contents"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" man

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-man 1 ls" ]]
}

@test "fz ssh" {
	FZF_MOCK_OUTPUT="myServer"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" ssh

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-ssh myServer" ]]
}

@test "fz tmux  # tmux not installed" {
	bats_require_minimum_version 1.5.0
	set +o errexit
	PATH="" run -127 bash "${BIN_FZ}" tmux

	[[ "${status}" != 0 ]]
	[[ "${output}" == "[fz error]:"*"tmux"* ]]
}

@test "fz tmux  # empty selection" {
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" tmux

	[[ "${status}" == 0 ]]
	[[ -z "${output}" ]]
}

@test "fz tmux  # enter session inside tmux" {
	FZF_MOCK_OUTPUT="enter\nsession mySession _ 2w"
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux switch-client -t mySession" ]]
}

@test "fz tmux  # enter session outside tmux" {
	FZF_MOCK_OUTPUT="enter\nsession mySession _ 2w"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux attach -t mySession" ]]
}

@test "fz tmux  # enter window inside tmux" {
	FZF_MOCK_OUTPUT="enter\nwindow mySession:0 bash 1p"
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux select-window -t mySession:0" ]]
}

@test "fz tmux  # enter window outside tmux" {
	FZF_MOCK_OUTPUT="enter\nwindow mySession:0 bash 1p"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux attach -t mySession ; select-window -t mySession:0" ]]
}

@test "fz tmux  # enter pane inside tmux" {
	FZF_MOCK_OUTPUT="enter\npane mySession:0.1 bash"
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux select-window -t mySession:0.1 ; select-pane -t mySession:0.1" ]]
}

@test "fz tmux  # enter pane outside tmux" {
	FZF_MOCK_OUTPUT="enter\npane mySession:0.1 bash"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux attach -t mySession ; select-pane -t mySession:0.1" ]]
}

@test "fz tmux  # ctrl-k session" {
	FZF_MOCK_OUTPUT="ctrl-k\nsession mySession _ 2w"
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux kill-session -t mySession" ]]
}

@test "fz tmux  # ctrl-k window" {
	FZF_MOCK_OUTPUT="ctrl-k\nwindow mySession:0 bash 1p"
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux kill-window -t mySession:0" ]]
}

@test "fz tmux  # ctrl-k pane" {
	FZF_MOCK_OUTPUT="ctrl-k\npane mySession:0.1 bash"
	TMUX="/run/tmux/1000/default,12345,0"

	PATH="${PATH_MOCKS}" run bash "${BIN_FZ}" tmux

	[[ "${status}" == 0 ]]
	[[ "${output}" == "mocked-tmux kill-pane -t mySession:0.1" ]]
}
