#!/usr/bin/env bash
set -eo pipefail

echo "*test*"
elixir "$1/solve.exs" <"$1/input/test.txt"

echo

echo "*solve*"
elixir "$1/solve.exs" <"$1/input/input.txt"
