setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'

    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
    export TESTDIR=$DIR/tmp
    export PROJNAME=craftcms-project
    mkdir -p $TESTDIR
    cd $TESTDIR
    # make executables in src/ visible to PATH
    PATH="$DIR:$PATH"
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "can run our ping task" {
    # notice the missing ./
    # As we added src/ to $PATH, we can omit the relative path to `src/project.sh`.
    run make --makefile=../Makefile ping
    assert_output 'pong'
}

@test "can run our tester task" {
    run make --makefile=../Makefile tester
    assert_output --partial 'first'
}

@test "can run our ddev-setup task" {
    run make --makefile=../Makefile ddev-setup <<< $PROJNAME
    assert_output --partial "Project $PROJNAME created!"
}

@test "can run our cms-setup task" {
    run make --makefile=../Makefile cms-setup <<< $PROJNAME
    assert_output --partial "Project $PROJNAME created!"
}