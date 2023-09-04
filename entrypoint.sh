#!/usr/bin/env bash

set -xe

if [ -z "${INPUT_GITHUB_TOKEN}" ] ; then
  echo "::notice title=GitHub API token::Consider setting a GITHUB_TOKEN to prevent GitHub api rate limits"
fi

REFINERY_VERSION=""
if [ "$INPUT_REFINERY_VERSION" != "latest" ] && [ -n "$INPUT_REFINERY_VERSION" ]; then
  REFINERY_VERSION="tags/${INPUT_REFINERY_VERSION}"
else
  REFINERY_VERSION="latest"
fi

function get_release_assets() {
  repo="$1"
  version="$2"

  args=(
    -sSL
    --header "Accept: application/vnd.github+json"
  )
  [ -n "${INPUT_GITHUB_TOKEN}" ] && args+=(--header "Authorization: Bearer ${INPUT_GITHUB_TOKEN}")

  if ! curl --fail-with-body -sS "${args[@]}" "https://api.github.com/repos/${repo}/releases/${version}"; then
    echo "::error title=GitHub API request failure::The request to the GitHub API was likely rate-limited. Set a GITHUB_TOKEN to prevent this"
    exit 1
  else
    curl "${args[@]}" "https://api.github.com/repos/${repo}/releases/${version}" | jq '.assets[] | { name: .name, download_url: .browser_download_url }'
  fi
}

function install_release() {
  repo="$1"
  version="$2"
  binary="$3_$4"
  platform="$4"
  release_assets="$(get_release_assets "${repo}" "${version}")"
  release_target="$(echo "${release_assets}" | jq -r ". | select(.name|match(\"${platform}\")) | .download_url")"

  curl -sLo "${binary}" "${release_target}"
  dpkg -i "${binary}"
}

install_release rust-db/refinery "${REFINERY_VERSION}" refinery "amd64.deb"

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

if [ -n "${INPUT_MIGRATION_DIRECTORY}" ]; then
  REFINERY_MIGRATION_DIRECTORY="-p ${INPUT_MIGRATION_DIRECTORY}"
fi

if [ -n "${INPUT_CONFIG}" ]; then
  REFINERY_CONFIG="-c ${INPUT_CONFIG}"
fi

if [ -n "${INPUT_DB_URI_ENV_VAR}" ]; then
  REFINERY_DB_URI="-e ${INPUT_DB_URI_ENV_VAR}"
fi

if [ "${INPUT_SINGLE_TRANSACTION}" == "true" ]; then
  REFINERY_SINGLE_TRANSACTION="-g"
fi

if [ -n "${INPUT_TARGET}" ]; then
  REFINERY_TARGET="-t ${INPUT_TARGET}"
fi

if [ -n "${INPUT_ADDITIONAL_ARGS}" ]; then
  REFINERY_ARGS_OPTION="${INPUT_ADDITIONAL_ARGS}"
fi

refinery migrate ${REFINERY_ARGS_OPTION} ${REFINERY_CONFIG} ${REFINERY_DB_URI} ${REFINERY_SINGLE_TRANSACTION} ${REFINERY_TARGET} ${INPUT_MIGRATION_DIRECTORY}
