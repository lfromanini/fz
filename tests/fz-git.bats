#!/usr/bin/env bats

function setup()
{
	load "support/common.bash"

	local gitWorktree="${BATS_TEST_TMPDIR}/worktree"

	mkdir -p -- "${gitWorktree}"
	cd -- "${gitWorktree}" || return $?

	git init -q
	git config user.name "Test User"
	git config user.email "test@example.com"

	printf 'initial content\n' > file.txt
	git add . file.txt
	git commit -qm "Initial commit"
}

@test "fz git ......................... # git not installed" {

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

@test "fz git ......................... # [ git ] requires a git working tree" {

	cd "${BATS_TEST_TMPDIR}"
	run bash "${FZ_BIN}" git

	[[ ${status} != 0 ]]
}

@test "fz git ......................... # [ branch ] switches to selected branch" {

	git branch feature

	setFzfMock git branch $'enter\nfeature\tabc123\t2 hours ago\trefs/heads/feature'
	run bash "${FZ_BIN}" git branch

	[[ ${status} == 0 ]]
	[[ $( git branch --show-current ) == "feature" ]]
}

@test "fz git ......................... # [ branch ] creates a new branch" {

    git branch feature

    setFzfMock git branch $'ctrl-n\nfeature\tabc123\t2 hours ago\trefs/heads/feature' new-feature-branch
    run bash "${FZ_BIN}" git branch

    [[ ${status} == 0 ]]
    [[ $( git branch --show-current ) == "new-feature-branch" ]]
}

@test "fz git ......................... # [ branch ] deletes selected local branch" {

	git branch feature

	setFzfMock git branch $'ctrl-d\nfeature\tabc123\t2 hours ago\trefs/heads/feature' Yes
	run bash "${FZ_BIN}" git branch

	[[ ${status} == 0 ]]
	[[ -z $( git branch --list feature ) ]]
}

@test "fz git ......................... # [ branch ] handles fzf cancellation" {

	setFzfMock git branch
	run bash "${FZ_BIN}" git branch

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz git ......................... # [ diff ] displays selected file diff" {

	printf 'modified content\n' > file.txt

	setFzfMock git diff file.txt
	run bash "${FZ_BIN}" git diff

	[[ ${status} == 0 ]]
	[[ $( stripColors "${output}" ) == *"modified content"* ]]
}

@test "fz git ......................... # [ diff ] handles fzf cancellation" {

	setFzfMock git diff
	run bash "${FZ_BIN}" git diff

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz git ......................... # [ log ] displays selected commit" {

	setFzfMock git log "$( git log -1 --format='%h' )"
	run bash "${FZ_BIN}" git log

	[[ ${status} == 0 ]]
	[[ $( stripColors "${output}" ) == *"Initial commit"* ]]
}

@test "fz git ......................... # [ log ] handles fzf cancellation" {

	setFzfMock git log
	run bash "${FZ_BIN}" git log

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz git ......................... # [ stash ] applies selected stash" {

	printf 'modified content\n' > file.txt
	git stash push -qm "test stash"

	setFzfMock git stash $'enter\nstash@{0}\t2 hours ago\tOn master: test stash'
	run bash "${FZ_BIN}" git stash

	[[ ${status} == 0 ]]
	[[ $( cat file.txt ) == "modified content" ]]
	[[ $( git stash list | wc -l ) == 1 ]]
}

@test "fz git ......................... # [ stash ] pops selected stash" {

	printf 'modified content\n' > file.txt
	git stash push -qm "test stash"

	setFzfMock git stash $'ctrl-p\nstash@{0}\t2 hours ago\tOn master: test stash'
	run bash "${FZ_BIN}" git stash

	[[ ${status} == 0 ]]
	[[ $( cat file.txt ) == "modified content" ]]
	[[ $( git stash list | wc -l ) == 0 ]]
}

@test "fz git ......................... # [ stash ] drops selected stash" {

	printf 'modified content\n' > file.txt
	git stash push -qm "test stash"

	setFzfMock git stash $'ctrl-d\nstash@{0}\t2 hours ago\tOn master: test stash' Yes
	run bash "${FZ_BIN}" git stash

	[[ ${status} == 0 ]]
	[[ $( git stash list | wc -l ) == 0 ]]
	[[ $( cat file.txt ) == "initial content" ]]
}

@test "fz git ......................... # [ stash ] handles drop cancellation" {

	printf 'modified content\n' > file.txt
	git stash push -qm "test stash"

	setFzfMock git stash $'ctrl-d\nstash@{0}\t2 hours ago\tOn master: test stash' No
	run bash "${FZ_BIN}" git stash

	[[ ${status} == 0 ]]
	[[ $( git stash list | wc -l ) == 1 ]]
	[[ $( cat file.txt ) == "initial content" ]]
}

@test "fz git ......................... # [ stash ] creates stash with message" {

	printf 'modified content\n' > file.txt

	setFzfMock git stash $'ctrl-n\n' "new stash message"
	run bash "${FZ_BIN}" git stash

	[[ ${status} == 0 ]]
	[[ $( git stash list --format='%gs' ) == *"new stash message"* ]]
	[[ $( cat file.txt ) == "initial content" ]]
}

@test "fz git ......................... # [ stash ] creates stash without message" {

	printf 'modified content\n' > file.txt

	setFzfMock git stash $'ctrl-n\n' ""
	run bash "${FZ_BIN}" git stash

	[[ ${status} == 0 ]]
	[[ $( git stash list | wc -l ) == 1 ]]
	[[ $( cat file.txt ) == "initial content" ]]
}

@test "fz git ......................... # [ stash ] handles fzf cancellation" {

	setFzfMock git stash
	run bash "${FZ_BIN}" git stash

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}

@test "fz git ......................... # [ tag ] checks out selected tag" {

	git tag v1.0.0

	setFzfMock git tag $'enter\nv1.0.0'
	run bash "${FZ_BIN}" git tag

	[[ ${status} == 0 ]]
	[[ $( git rev-parse HEAD ) == "$( git rev-parse v1.0.0 )" ]]
	[[ -z $( git branch --show-current ) ]]
}

@test "fz git ......................... # [ tag ] deletes selected local tag" {

	git tag v1.0.0

	setFzfMock git tag $'ctrl-d\nv1.0.0' local
	run bash "${FZ_BIN}" git tag

	[[ ${status} == 0 ]]
	bats_require_minimum_version 1.5.0
	run ! git show-ref --verify --quiet refs/tags/v1.0.0
}

@test "fz git ......................... # [ tag ] deletes selected remote tag" {

	local remote="${BATS_TEST_TMPDIR}/remote.git"

	git init --bare -q "${remote}"
	git remote add origin "${remote}"

	git tag v1.0.0
	git push -q origin v1.0.0

	setFzfMock git tag $'ctrl-d\nv1.0.0' remote/origin
	run bash "${FZ_BIN}" git tag

	[[ ${status} == 0 ]]
	[[ -z $( git ls-remote --tags origin refs/tags/v1.0.0 ) ]]
}

@test "fz git ......................... # [ tag ] ignores tag not found on selected remote" {

	local remote="${BATS_TEST_TMPDIR}/remote.git"

	git init --bare -q "${remote}"
	git remote add origin "${remote}"

	git tag v1.0.0

	setFzfMock git tag $'ctrl-d\nv1.0.0' remote/origin
	run bash "${FZ_BIN}" git tag

	[[ ${status} == 0 ]]
	[[ -n $( git show-ref --verify refs/tags/v1.0.0 ) ]]
	[[ -z $( git ls-remote --tags origin refs/tags/v1.0.0 ) ]]
}

@test "fz git ......................... # [ tag ] aborts when remote tag lookup fails" {

	local remote="${BATS_TEST_TMPDIR}/missing.git"

	git remote add origin "${remote}"
	git tag v1.0.0

	setFzfMock git tag $'ctrl-d\nv1.0.0' remote/origin
	run bash "${FZ_BIN}" git tag

	[[ ${status} != 0 ]]
	[[ ${output} == *"failed to check tag"* ]]
	[[ -n $( git show-ref --verify refs/tags/v1.0.0 ) ]]
}

@test "fz git ......................... # [ tag ] creates lightweight tag pointing to selected commit" {

	local remote="${BATS_TEST_TMPDIR}/remote.git"
	local commit=

	git init --bare -q "${remote}"
	git remote add origin "${remote}"

	git tag v0.9.0

	printf 'second commit\n' > file.txt
	git add file.txt
	git commit -qm "Second commit"

	commit=$( git rev-list --max-count=2 HEAD | tail -n 1 )

	setFzfMock git tag $'ctrl-n\nv0.9.0' "v1.0.0" "" "${commit}" remote/origin
	run bash "${FZ_BIN}" git tag

	[[ ${status} == 0 ]]
	[[ $( git cat-file -t refs/tags/v1.0.0 ) == commit ]]
	[[ $( git rev-parse v1.0.0 ) == "${commit}" ]]
	[[ -n $( git ls-remote --tags origin refs/tags/v1.0.0 ) ]]
}

@test "fz git ......................... # [ tag ] creates annotated tag with message" {

	local remote="${BATS_TEST_TMPDIR}/remote.git"
	local commit=

	git init --bare -q "${remote}"
	git remote add origin "${remote}"

	git tag v0.9.0
	commit=$( git rev-parse HEAD )

	setFzfMock git tag $'ctrl-n\nv0.9.0' "v1.0.0" "Release 1.0.0" "${commit}" remote/origin
	run bash "${FZ_BIN}" git tag

	[[ ${status} == 0 ]]
	[[ $( git cat-file -t refs/tags/v1.0.0 ) == tag ]]
	[[ $( git for-each-ref --format='%(contents:subject)' refs/tags/v1.0.0 ) == "Release 1.0.0" ]]
	[[ $( git rev-parse 'v1.0.0^{}' ) == "${commit}" ]]
	[[ -n $( git ls-remote --tags origin refs/tags/v1.0.0 ) ]]
}

@test "fz git ......................... # [ tag ] handles fzf cancellation" {

	setFzfMock git tag
	run bash "${FZ_BIN}" git tag

	[[ ${status} == 0 ]]
	[[ -z ${output} ]]
}
