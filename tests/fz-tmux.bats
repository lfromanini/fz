#!/usr/bin/env bats

function setup()
{
	load "support/common.bash"
	export TMUX="/run/tmux/1000/default,12345,0"
}

@test "fz tmux ................ # tmux not installed" {

	function command()
	{
		[[ $1 == -v ]] && case $2 in
			tmux)
				printf "%s: command not found\n" "$2" >&2
				return 1
			;;
		esac

		builtin command "$@"
	}

	export -f command

	setFzfMock tmux

	bats_require_minimum_version 1.5.0
	set +o errexit
	run -127 bash "${FZ_BIN}" tmux

	[[ ${status} == 127 ]]
	[[ ${output} == "[fz error]:"*"tmux"* ]]
}

@test "fz tmux ................ # empty selection" {

	setFzfMock tmux
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" tmux

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz tmux ................ # [ esc ] handles fzf cancellation" {

	setFzfMock tmux
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" tmux

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz tmux ................ # [ enter ] session inside tmux" {

	setFzfMock tmux $'enter\nsession mySession _ 2w'
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" tmux

	[[ ${status} == 0 ]]
	[[ ${output} == "mocked-tmux switch-client -t mySession" ]]
}

@test "fz tmux ................ # [ enter ] session outside tmux" {

	unset TMUX

	setFzfMock tmux $'enter\nsession mySession _ 2w'
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" tmux

	[[ ${status} == 0 ]]
	[[ ${output} == "mocked-tmux attach -t mySession" ]]
}

@test "fz tmux ................ # [ enter ] window inside tmux" {

	setFzfMock tmux $'enter\nwindow mySession:0 bash 1p'
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" tmux

	[[ ${status} == 0 ]]
	[[ ${output} == "mocked-tmux select-window -t mySession:0" ]]
}

@test "fz tmux ................ # [ enter ] window outside tmux" {

	unset TMUX

	setFzfMock tmux $'enter\nwindow mySession:0 bash 1p'
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" tmux

	[[ ${status} == 0 ]]
	[[ ${output} == "mocked-tmux attach -t mySession ; select-window -t mySession:0" ]]
}

@test "fz tmux ................ # [ enter ] pane inside tmux" {

	setFzfMock tmux $'enter\npane mySession:0.1 bash'
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" tmux

	[[ ${status} == 0 ]]
	[[ ${output} == "mocked-tmux select-window -t mySession:0.1 ; select-pane -t mySession:0.1" ]]
}

@test "fz tmux ................ # [ enter ] pane outside tmux" {

	unset TMUX

	setFzfMock tmux $'enter\npane mySession:0.1 bash'
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" tmux

	[[ ${status} == 0 ]]
	[[ ${output} == "mocked-tmux attach -t mySession ; select-pane -t mySession:0.1" ]]
}

@test "fz tmux ................ # [ ctrl-k ] session" {

	setFzfMock tmux $'ctrl-k\nsession mySession _ 2w' Yes
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" tmux

	[[ ${status} == 0 ]]
	[[ ${output} == "mocked-tmux kill-session -t mySession" ]]
}

@test "fz tmux ................ # [ ctrl-k ] window" {

	setFzfMock tmux $'ctrl-k\nwindow mySession:0 bash 1p' Yes
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" tmux

	[[ ${status} == 0 ]]
	[[ ${output} == "mocked-tmux kill-window -t mySession:0" ]]
}

@test "fz tmux ................ # [ ctrl-k ] pane" {

	setFzfMock tmux $'ctrl-k\npane mySession:0.1 bash' Yes
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" tmux

	[[ ${status} == 0 ]]
	[[ ${output} == "mocked-tmux kill-pane -t mySession:0.1" ]]
}
