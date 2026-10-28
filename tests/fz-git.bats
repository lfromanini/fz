#!/usr/bin/env bats

function setup() {
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

function teardown() {
	[[ -z ${GIT_DIR:-} ]] || rm -fR "${GIT_DIR}"
}

@test "fz git ................. # [ git ] rejects unsupported commands" {

	run bash "${PATH_BIN}"/fz git invalid

	[[ "${status}" == 2 ]]
	[[ "$( stripColors "${output}" )" == *"Invalid fz::git argument"* ]]
}

@test "fz git ................. # [ git ] requires a git working tree" {

	cd "${BATS_TEST_TMPDIR}" || return $?

	run bash "${PATH_BIN}"/fz git log

	[[ "${status}" != 0 ]]
}

@test "fz git ................. # [ branch ] switches to selected branch" {

	git branch feature

	FZF_MOCK_OUTPUT="feature"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz git branch

	[[ "${status}" == 0 ]]
	[[ "$( git branch --show-current )" == "feature" ]]
}

@test "fz git ................. # [ branch ] handles fzf cancellation" {

	mockFzfEscape
	run bash "${PATH_BIN}"/fz git branch

	[[ "${status}" == 0 ]]
	[[ -z "${output}" ]]
}

@test "fz git ................. # [ diff ] displays selected file diff" {

	printf 'modified content\n' > file.txt

	FZF_MOCK_OUTPUT="M file.txt"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz git diff

	[[ "${status}" == 0 ]]
	[[ "$( stripColors "${output}" )" == *"modified content"* ]]
}

@test "fz git ................. # [ diff ] handles fzf cancellation" {

	mockFzfEscape
	run bash "${PATH_BIN}"/fz git diff

	[[ "${status}" == 0 ]]
	[[ -z "${output}" ]]
}

@test "fz git ................. # [ log ] displays selected commit" {

	# shellcheck disable=SC2034     # SC2034: foo appears unused. Verify it or export it.
	FZF_MOCK_OUTPUT="$( git log -1 --format='%h' )"

	PATH="${PATH_MOCKS}" run bash "${PATH_BIN}"/fz git log

	[[ "${status}" == 0 ]]
	[[ "$( stripColors "${output}" )" == *"Initial commit"* ]]
}

@test "fz git ................. # [ log ] handles fzf cancellation" {

	mockFzfEscape
	run bash "${PATH_BIN}"/fz git log

	[[ "${status}" == 0 ]]
	[[ -z "${output}" ]]
}
