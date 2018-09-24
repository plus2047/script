# use: source ~/script/proxy.sh
if [ ! -z $1 ]
then
    if [ $1 = 'unset' ]
    then
        unset HTTP_PROXY
        unset HTTPS_PROXY
        unset ALL_PROXY
        unset http_proxy
        unset https_proxy
    else
        export HTTP_PROXY=http://localhost:$1
        export HTTPS_PROXY=$HTTP_PROXY
        export http_proxy=$HTTP_PROXY
        export https_proxy=$HTTP_PROXY
        if [ -n "$2" ]
        then
            export ALL_PROXY=socks5://localhost:$2
        fi
    fi
fi


