#!/bin/bash
echo "Your PATH is $PATH"
echo "You are on branch $TRAVIS_BRANCH"
echo "The TRAVIS_PULL_REQUEST_BRANCH is $TRAVIS_PULL_REQUEST_BRANCH"
if [[ "$TRAVIS_PULL_REQUEST_BRANCH" = "" ]]
then
    echo "you are on master, deploying production."
    netlify deploy --prod --dir=public
else
    echo "you are not on master, deploying preview."
    netlify deploy --dir=public
fi
