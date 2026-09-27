#!/usr/bin/env bash

export TEST_PID="NOT_A_PID"

function spawnTestProcess()
{
	sleep 15 &
	TEST_PID=$!
}
