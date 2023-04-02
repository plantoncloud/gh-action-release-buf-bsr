#!/bin/sh
set -o errexit
set -o nounset

export PLANTON_CLOUD_SERVICE_CLI_ENV=${1}
export PLANTON_CLOUD_SERVICE_CLIENT_ID=${2}
export PLANTON_CLOUD_SERVICE_CLIENT_SECRET=${3}
export PLANTON_CLOUD_ARTIFACT_STORE_ID=${4}
export RELEASE_VERSION=${5}

if ! [ -n "${PLANTON_CLOUD_SERVICE_CLIENT_ID}" ]; then
  echo "PLANTON_CLOUD_SERVICE_CLIENT_ID is not set. Configure Machine Account Credentials for Repository or Organization."
  exit 1
fi
if ! [ -n "${PLANTON_CLOUD_SERVICE_CLIENT_SECRET}" ]; then
  echo "PLANTON_CLOUD_SERVICE_CLIENT_SECRET is not set. Configure Machine Account Credentials for Repository or Organization."
  exit 1
fi
if ! [ -n "${PLANTON_CLOUD_ARTIFACT_STORE_ID}" ]; then
  echo "PLANTON_CLOUD_ARTIFACT_STORE_ID is required. It should be set to the id of the artifact-store on planton cloud"
  exit 1
fi
if ! [ -n "${RELEASE_VERSION}" ]; then
  echo "RELEASE_VERSION is required. It should be set to the semantic version of the protobuf definitions to be used for the release"
  exit 1
fi

#!/bin/bash
set -o errexit
set -o nounset

echo "exchanging planton-cloud machine-account credentials to get an access token"
planton auth machine login \
  --client-id $PLANTON_CLOUD_SERVICE_CLIENT_ID \
  --client-secret $PLANTON_CLOUD_SERVICE_CLIENT_SECRET
echo "successfully exchanged planton-cloud machine-account credentials and received an access token"
#consumer projects of this action are expected to have a Makefile in the root of the repository and also
# a target with name 'release'
echo "release protobufs to buf schema registry"
echo "releasing version: $RELEASE_VERSION"
make release version=$RELEASE_VERSION
