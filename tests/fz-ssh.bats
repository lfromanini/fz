#!/usr/bin/env bats

function setup() { load "support/common.bash" ; }

@test "fz ssh ................. # connect to valid server" {

	setFzfMock ssh myServer
	PATH="${PATH_MOCKS}" run bash "${FZ_BIN}" ssh

	[[ ${status} == 0 ]]
	[[ ${output} == "mocked-ssh myServer --" ]]
}

@test "fz ssh ................. # [ esc ] handles fzf cancellation" {

	setFzfMock ssh
	run bash "${FZ_BIN}" ssh

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}
