#!/usr/bin/env bats

function setup()
{
	load "support/common.bash"

	GIT_DIR=$( mktemp -d )
	GIT_WORK_TREE="${GIT_DIR}/worktree"

	mkdir -p "${GIT_WORK_TREE}"
	git -C "${GIT_WORK_TREE}" init -q
	git -C "${GIT_WORK_TREE}" config user.name "Test User"
	git -C "${GIT_WORK_TREE}" config user.email "test@example.com"

	printf 'initial content\n' > "${GIT_WORK_TREE}/file.txt"
	git -C "${GIT_WORK_TREE}" add file.txt
	git -C "${GIT_WORK_TREE}" commit -qm "Initial commit"

	cd "${GIT_WORK_TREE}" || return $?
}

function teardown()
{
	rm -f "${FZF_MOCK_OUTPUT_FILE}"
	rm -fR "${GIT_DIR}"
}

@test "fz git ................. # git not installed" {

	function command()
	{
		[[ $1 == -v ]] && case $2 in
			git)
				printf "%s: command not found\n" "$2" >&2
				return 1
			;;
		esac

		builtin command "$@"
	}

	export -f command

	setFzfMock git

	bats_require_minimum_version 1.5.0
	set +o errexit
	run -127 bash "${FZ_BIN}" git

	[[ ${status} == 127 ]]
	[[ ${output} == "[fz error]:"*"git"* ]]
}

@test "fz git ................. # [ git ] requires a git working tree" {

	cd "${BATS_TEST_TMPDIR}" || return $?
	run bash "${FZ_BIN}" git

	[[ ${status} != 0 ]]
}

@test "fz git ................. # [ branch ] switches to selected branch" {

	git branch feature

	setFzfMock git branch feature
	run bash "${FZ_BIN}" git branch

	[[ ${status} == 0 ]]
	[[ $( git branch --show-current ) == "feature" ]]
}

@test "fz git ................. # [ branch ] handles fzf cancellation" {

	setFzfMock git branch
	run bash "${FZ_BIN}" git branch

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz git ................. # [ diff ] displays selected file diff" {

	printf 'modified content\n' > file.txt

	setFzfMock git diff "M file.txt"
	run bash "${FZ_BIN}" git diff

	[[ ${status} == 0 ]]
	[[ $( stripColors "${output}" ) == *"modified content"* ]]
}

@test "fz git ................. # [ diff ] handles fzf cancellation" {

	setFzfMock git diff
	run bash "${FZ_BIN}" git diff

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz git ................. # [ log ] displays selected commit" {

	setFzfMock git log "$( git log -1 --format='%h' )"
	run bash "${FZ_BIN}" git log

	[[ ${status} == 0 ]]
	[[ $( stripColors "${output}" ) == *"Initial commit"* ]]
}

@test "fz git ................. # [ log ] handles fzf cancellation" {

	setFzfMock git log
	run bash "${FZ_BIN}" git log

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}
