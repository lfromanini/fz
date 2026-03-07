#!/usr/bin/env bats

# shellcheck disable=SC1090     # SC1090: Can't follow non-constant source. Use a directive to specify location
# shellcheck disable=SC2030     # SC2030: Modification of var is local (to subshell caused by pipeline).
# shellcheck disable=SC2031     # SC2031: var was modified in a subshell. That change might be lost.

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

@test "fz       # no arguments provided" {
	run bash "${FZ}"

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == *"Usage:"* ]]
}

@test "fz --version" {
	source "${FZ}"

	run bash "${FZ}" --version

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "fz ${VERSION}" ]]
}

@test "fz -V" {
	source "${FZ}"

	run bash "${FZ}" -V

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "fz ${VERSION}" ]]
}

@test "fz       # fzf not installed" {
	local PATH=""

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
	local PATH="${PATH_MOCKS}:${PATH}"

	export FZF_MOCK_OUTPUT="user 12345 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash"

	run bash "${FZ}" kill

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-kill -SIGTERM 12345" ]]
}

@test "fz kill -9" {
	local PATH="${PATH_MOCKS}:${PATH}"

	export FZF_MOCK_OUTPUT="user 12345 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash"

	run bash "${FZ}" kill -9

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-kill -9 12345" ]]
}

@test "fz man" {
	local PATH="${PATH_MOCKS}:${PATH}"

	export FZF_MOCK_OUTPUT="ls (1)               - list directory contents"

	run bash "${FZ}" man

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-man 1 ls" ]]
}

@test "fz ssh" {
	local PATH="${PATH_MOCKS}:${PATH}"

	export FZF_MOCK_OUTPUT="myServer"

	run bash "${FZ}" ssh

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-ssh myServer" ]]
}

@test "fz tmux  # tmux not installed" {
	local PATH=""

	bats_require_minimum_version 1.5.0
	set +o errexit
	run -127 bash "${FZ}" tmux

	[[ "${status}" -ne 0 ]]
	[[ "${output}" == "[fz error]:"*"tmux"* ]]
}

@test "fz tmux  # empty selection" {
	local PATH="${PATH_MOCKS}:${PATH}"

	export FZF_MOCK_OUTPUT=""

	run bash "${FZ}" tmux

	[[ "${status}" -eq 0 ]]
	[[ -z "${output}" ]]
}

@test "fz tmux  # enter session inside tmux" {
	local PATH="${PATH_MOCKS}:${PATH}"

	export TMUX="/run/tmux/1000/default,12345,0"
	export FZF_MOCK_OUTPUT="enter\nsession mySession _ 2w"

	run bash "${FZ}" tmux

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-tmux switch-client -t mySession" ]]
}

@test "fz tmux  # enter session outside tmux" {
	local PATH="${PATH_MOCKS}:${PATH}"

	unset TMUX
	export FZF_MOCK_OUTPUT="enter\nsession mySession _ 2w"

	run bash "${FZ}" tmux

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-tmux attach -t mySession" ]]
}

@test "fz tmux  # enter window inside tmux" {
	local PATH="${PATH_MOCKS}:${PATH}"

	export TMUX="/tmp/tmux-1000/default,12345,0"
	export FZF_MOCK_OUTPUT="enter\nwindow mySession:0 bash 1p"

	run bash "${FZ}" tmux

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-tmux select-window -t mySession:0" ]]
}

@test "fz tmux  # enter window outside tmux" {
	local PATH="${PATH_MOCKS}:${PATH}"

	unset TMUX
	export FZF_MOCK_OUTPUT="enter\nwindow mySession:0 bash 1p"

	run bash "${FZ}" tmux

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-tmux attach -t mySession ; select-window -t mySession:0" ]]
}

@test "fz tmux  # enter pane inside tmux" {
	local PATH="${PATH_MOCKS}:${PATH}"

	export TMUX="/tmp/tmux-1000/default,12345,0"
	export FZF_MOCK_OUTPUT="enter\npane mySession:0.1 bash"

	run bash "${FZ}" tmux

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-tmux select-window -t mySession:0.1 ; select-pane -t mySession:0.1" ]]
}

@test "fz tmux  # enter pane outside tmux" {
	local PATH="${PATH_MOCKS}:${PATH}"

	unset TMUX
	export FZF_MOCK_OUTPUT="enter\npane mySession:0.1 bash"

	run bash "${FZ}" tmux

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-tmux attach -t mySession ; select-pane -t mySession:0.1" ]]
}

@test "fz tmux  # ctrl-k session" {
	local PATH="${PATH_MOCKS}:${PATH}"

	export FZF_MOCK_OUTPUT="ctrl-k\nsession mySession _ 2w"

	run bash "${FZ}" tmux

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-tmux kill-session -t mySession" ]]
}

@test "fz tmux  # ctrl-k window" {
	local PATH="${PATH_MOCKS}:${PATH}"

	export FZF_MOCK_OUTPUT="ctrl-k\nwindow mySession:0 bash 1p"

	run bash "${FZ}" tmux

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-tmux kill-window -t mySession:0" ]]
}

@test "fz tmux  # ctrl-k pane" {
	local PATH="${PATH_MOCKS}:${PATH}"

	export FZF_MOCK_OUTPUT="ctrl-k\npane mySession:0.1 bash"

	run bash "${FZ}" tmux

	[[ "${status}" -eq 0 ]]
	[[ "${output}" == "mocked-tmux kill-pane -t mySession:0.1" ]]
}
