#!/usr/bin/env bats

function setup() { load "support/common.bash" ; }

function spawnTestProcess()
{
	local pid=

	sleep 10 &
	pid=$!

	TARGET_PROCESS_ENTER="enter"$'\n'"user ${pid} 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash"
	TARGET_PROCESS_CTRL_K="ctrl-k"$'\n'"user ${pid} 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash"
}

@test "fz kill ................ # [ esc ] handles fzf cancellation" {

	setFzfMock kill
	run bash "${FZ_BIN}" kill

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz kill ................ # [ enter ] kill with default -SIGTERM" {

	spawnTestProcess

	setFzfMock kill "${TARGET_PROCESS_ENTER}"
	run bash "${FZ_BIN}" kill

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz kill -SIGKILL ....... # [ enter ] kill with valid signal" {

	spawnTestProcess

	setFzfMock kill "${TARGET_PROCESS_ENTER}"
	run bash "${FZ_BIN}" kill -SIGKILL

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz kill -9 ............. # [ enter ] kill with valid signal number" {

	spawnTestProcess

	setFzfMock kill "${TARGET_PROCESS_ENTER}"
	run bash "${FZ_BIN}" kill -9

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz kill -NOT_A_SIGNAL .. # [ enter ] kill with invalid signal" {

	setFzfMock kill
	run bash "${FZ_BIN}" kill -NOT_A_SIGNAL

	[[ ${status} == 1 ]]
	[[ $( stripColors "${output}" ) == *"Invalid fz::kill signal"* ]]
}

@test "fz kill --SIGTERM ...... # [ enter ] kill with invalid signal" {

	setFzfMock kill
	run bash "${FZ_BIN}" kill --SIGTERM

	[[ ${status} == 1 ]]
	[[ $( stripColors "${output}" ) == *"Invalid fz::kill signal"* ]]
}

@test "fz kill 9 .............. # [ enter ] kill with invalid signal" {

	setFzfMock kill
	run bash "${FZ_BIN}" kill 9

	[[ ${status} == 1 ]]
	[[ $( stripColors "${output}" ) == *"Invalid fz::kill signal"* ]]
}

@test "fz kill ................ # [ ctrl-k ] kill with -SIGKILL" {

	spawnTestProcess

	setFzfMock kill "${TARGET_PROCESS_CTRL_K}" Yes
	run bash "${FZ_BIN}" kill

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}
