#!/bin/sh

git filter-branch --env-filter '
OLD_EMAIL="xjh_cn@yeah.net"
CORRECT_NAME="jiahao.xu"
CORRECT_EMAIL="jiahao.xu@hulu.com"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' -- --branches --max-count=10


