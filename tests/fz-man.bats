#!/usr/bin/env bats

function setup() { load "support/common.bash" ; }

@test "fz man ................. # valid manual page" {

	setFzfMock man "ls (1)               - list directory contents"
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" man

	[[ ${status} == 0 ]]
	[[ ${output} == "mocked-man 1 ls" ]]
}

@test "fz man ................. # [ esc ] handles fzf cancellation" {

	setFzfMock man
	run bash "${FZ_BIN}" man

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}
