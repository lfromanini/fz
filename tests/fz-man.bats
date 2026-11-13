#!/usr/bin/env bats

function setup() { load "support/common.bash" ; }

@test "fz man ................. # valid manual page" {

	setFzfMock man "man (1)"
	MAN_POSIXLY_CORRECT=1 MANPAGER=cat run bash "${FZ_BIN}" man

	[[ ${status} == 0 ]]
	[[ ${output} == "MAN(1)"* ]]
}

@test "fz man ................. # [ esc ] handles fzf cancellation" {

	setFzfMock man
	run bash "${FZ_BIN}" man

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}
