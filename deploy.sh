#!/bin/bash
echo "Your PATH is $PATH"
echo "You are on branch $TRAVIS_BRANCH"
echo "The working directory is $(pwd)"

if [ "$TRAVIS_BRANCH" = "master" ]
then
    echo "you are on master, deploying production."
    netlify deploy -a $NETLIFYKEY --prod --dir=public
else
    echo "you are not on master, deploying preview."
    netlify deploy -a $NETLIFYKEY --dir=public
fi
