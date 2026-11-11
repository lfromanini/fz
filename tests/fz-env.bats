#!/usr/bin/env bats

function setup() { load "support/common.bash" ; }

@test "fz env ................. # valid environment variable" {

	setFzfMock env HOME
	run bash "${FZ_BIN}" env

	[[ ${status} == 0 ]]
	[[ $( stripColors "${output}" ) == "HOME=${HOME}" ]]
}

@test "fz env ................. # [ esc ] handles fzf cancellation" {

	setFzfMock env
	run bash "${FZ_BIN}" env

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}
