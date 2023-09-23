# syntax=docker/dockerfile:1.3
FROM python:3.11-slim AS base-deps

ENV WORKSPACE_PATH=/workspace/
ENV PYTHONPATH=$PYTHONPATH:${WORKSPACE_PATH}/src
ENV PYTHONUNBUFFERED=1

# Install poetry
ARG POETRY_VERSION=1.6.1
ENV PIP_DEFAULT_TIMEOUT=60 \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    VENV_PATH=${WORKSPACE_PATH}/.venv
RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install --no-cache-dir poetry==${POETRY_VERSION}

ENV PATH=$VENV_PATH/bin:$PATH

# Install dependencies
COPY pyproject.toml poetry.lock ${WORKSPACE_PATH}/
RUN poetry install --directory=${WORKSPACE_PATH} --no-root --only main

WORKDIR /workspace
EXPOSE 80

COPY src ${WORKSPACE_PATH}/src/
COPY pyproject.toml ${WORKSPACE_PATH}/

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "80"]
