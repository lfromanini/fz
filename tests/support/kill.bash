#!/usr/bin/env bash

export TEST_PID="NOT_A_PID"

function spawnTestProcess()
{
	sleep 10 &
	TEST_PID=$!
}
