#!/usr/bin/env bash

function stripColors()
{
	printf '%s' "$*" | sed $'s/\033\\[[0-9;]*m//g'
}
