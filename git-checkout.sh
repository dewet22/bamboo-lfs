#!/usr/bin/env bash

set -ex

REPO=$bamboo_planRepository_repositoryUrl
WORKDIR=$bamboo_build_working_directory
BRANCH=$bamboo_planRepository_branch
COMMIT=$bamboo_planRepository_revision

if [ "$REPO" = "" ]; then
  echo 'Please specify a repo using $bamboo_planRepository_repositoryUrl !'
  exit 1
elif [ "$WORKDIR" = "" ]; then
  echo 'Please specify a working directory using $bamboo_build_working_directory !'
  exit 1
elif [ "$BRANCH" = "" ]; then
  echo 'Please specify a branch using $bamboo_planRepository_branch !'
  exit 1
elif [ "$COMMIT" = "" ]; then
  echo 'Please specify a commit using $bamboo_planRepository_revision !'
  exit 1
fi

echo "Repo: $REPO"
echo "Working directory: $WORKDIR"
echo "Branch: $BRANCH"
echo "Commit: $COMMIT"

if [ ! -d "$WORKDIR" ]; then
  echo 'Cloning clean repo to working directory...'
  git clone $REPO $WORKDIR
  cd $WORKDIR
else
  cd $WORKDIR
  if [ ! -d ".git" ]; then
    echo 'Working directory clean, cloning clean repo...'
    git clone $REPO .
  else
    repo=$(git config --get remote.origin.url)

    if [ "$repo" != "$REPO" ]; then
      echo "Existing repo $repo does not match specified repo $REPO\; aborting"
      exit 10
    fi

    echo 'Updating existing repo...'
    git fetch --prune
  fi
fi

git clean -xdf
git checkout -f -B $BRANCH $COMMIT
#git reset --hard $COMMIT
git clean -xdf
