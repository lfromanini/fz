#!/usr/bin/env bats

function setup() { load "support/common.bash" ; }

function spawnTestProcess()
{
	sleep 10 &
	TEST_PID=$!
}

@test "fz kill ................ # [ esc ] handles fzf cancellation" {

	setFzfMock kill
	run bash "${FZ_BIN}" kill

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz kill ................ # [ enter ] kill with default -SIGTERM" {

	spawnTestProcess

	setFzfMock kill $'enter\nuser '"${TEST_PID}"' 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'
	run bash "${FZ_BIN}" kill

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz kill -SIGKILL ....... # [ enter ] kill with valid signal" {

	spawnTestProcess

	setFzfMock kill $'enter\nuser '"${TEST_PID}"' 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'
	run bash "${FZ_BIN}" kill -SIGKILL

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz kill -9 ............. # [ enter ] kill with valid signal number" {

	spawnTestProcess

	setFzfMock kill $'enter\nuser '"${TEST_PID}"' 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'
	run bash "${FZ_BIN}" kill -9

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz kill -NOT_A_SIGNAL .. # [ enter ] kill with invalid signal" {

	setFzfMock kill $'enter\nuser 12345 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'
	run bash "${FZ_BIN}" kill -NOT_A_SIGNAL

	[[ ${status} == 1 ]]
	[[ $( stripColors "${output}" ) == *"Invalid fz::kill signal"* ]]
}

@test "fz kill --SIGTERM ...... # [ enter ] kill with invalid signal" {

	setFzfMock kill $'enter\nuser 12345 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'
	run bash "${FZ_BIN}" kill --SIGTERM

	[[ ${status} == 1 ]]
	[[ $( stripColors "${output}" ) == *"Invalid fz::kill signal"* ]]
}

@test "fz kill 9 .............. # [ enter ] kill with invalid signal" {

	setFzfMock kill $'enter\nuser 12345 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash'
	run bash "${FZ_BIN}" kill 9

	[[ ${status} == 1 ]]
	[[ $( stripColors "${output}" ) == *"Invalid fz::kill signal"* ]]
}

@test "fz kill ................ # [ ctrl-k ] kill with -SIGKILL" {

	spawnTestProcess

	setFzfMock kill $'ctrl-k\nuser '"${TEST_PID}"' 0.0 0.1 12345 1234 pts/0 S+ 10:00 0:00 bash' Yes
	run bash "${FZ_BIN}" kill

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}
