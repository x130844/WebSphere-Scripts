#!/bin/bash
# 
# Written by Frederic Fouche 2024
# this script gathers basic info about the runtime related to the process passed as argument. 
# Usage: 
# curl -sSL https://raw.githubusercontent.com/x130844/WebSphere-Scripts/main/mgather.sh |bash -s -- processname
# Example, for Liberty:
# curl -sSL https://raw.githubusercontent.com/x130844/WebSphere-Scripts/main/mgather.sh |bash -s -- java
#

sepline="\n"

printf "$sepline"
printf "$sepline"

if [ "$(uname)" != "Linux" ]
then
        echo "Script only compatible with Linux"
        exit
fi

if [ "$(pidof $1)" == "" ]
then
        echo "'$1' process not found, if you're looking for Liberty or WebSphere, use 'java' for the process."
        exit
fi

echo "Mustgather Info about process: \"$1\""

for mypid in $(pidof $1);
do
        mypath="$(readlink /proc/$mypid/exe)\n$mypath"
        mycwd="$(readlink /proc/$mypid/cwd)\n$mycwd"
        #myenv="$(tr -d '\0' </proc/$mypid/environ)\n$myenv"
        myenv="$(tr '\0' ' '</proc/$mypid/environ)\n$myenv"
        mycmdline="$(tr '\0' ' ' </proc/$mypid/cmdline; echo)\n$mycmdline"
        myulimit="$(tr '\0' '\n' </proc/$mypid/limits)\n$myulimit"
        myowner="$(ps -o user= -p $mypid )\n$myowner"
done

printf "$sepline"

echo "Current user's printenv output:"
printenv

printf "$sepline"

echo "Environment variables for active $1:"
printf "$myenv"|uniq

printf "$sepline"

echo "Command line arguments for active $1:"
printf "$mycmdline"|sort|uniq

printf "$sepline"

echo "ulimits values for $1:"
printf "$myulimit"|sort|uniq

printf "$sepline"

echo "Server is running:" $(grep PRETTY_NAME /etc/os-release | cut -f 2 -d "=")

if ! command -v sestatus &> /dev/null
then
        echo "Checked for SELinux, but not applicable here"
else
        sestatus
fi

printf "$sepline"

echo "Owner(s) for $1 session(s):"
printf "$myowner"|sort|uniq

printf "$sepline"

echo "Real binary Path(s) for active $1:"
printf "$mypath"|uniq

printf "$sepline"

echo "Current working dir(s) for $1:"
printf "$mycwd"|uniq

printf "$sepline"



