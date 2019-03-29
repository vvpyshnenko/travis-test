#!/bin/bash

if [ ! "$TRAVIS_PULL_REQUEST" == "false" ]; then
    echo "PR"
elif [ "$TRAVIS_BRANCH" == "develop" ]; then
    echo "MERGE_TO_DEVELOP"
elif [ "$TRAVIS_BRANCH" == "master" ]; then
    echo "MERGE_TO_MASTER"
elif [[ "$TRAVIS_BRANCH" =~ ^hotfix/.*$ ]]; then
    echo "MERGE_TO_HOTFIX"
if [ ! -z $TRAVIS_TAG ]; then
    VERSION=$(node -pe "require('../../lerna.json').version")
    REAL_BRANCH=$(git ls-remote origin | sed -n "\|$TRAVIS_COMMIT\s\+refs/heads/|{s///p}")
    if [ "$REAL_BRANCH" == "master" ] || [[ "$REAL_BRANCH" =~ ^hotfix/.*$ ]]; then
	# VALIDATE HAVE PROPER TAG
	if [ "$TRAVIS_TAG" == "v$VERSION" ]; then
	    echo "RELEASE"
	else
	    echo "Incorrect Release tag"
	    exit 1
	fi;
    fi;
else
    echo "ILLEGAL_ACTION"
    exit 1
fi
