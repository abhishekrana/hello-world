#!/bin/bash

set -ex

POETRY_VIRTUALENVS_CREATE=1
POETRY_VIRTUALENVS_IN_PROJECT=1

rm -rf ~/.cache/pypoetry/virtualenvs/hello-world*
mkdir -p .venv

poetry install
poetry env info

echo -e "\nsource .venv/bin/activate"
