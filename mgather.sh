#!/bin/bash
#echo ""
#echo "Mustgather Info about process: $1"
if [ "$(pidof $1)" == "" ]
then
	echo "$1 process not found"
	exit
fi

#echo $(pidof $1)
for mypid in $(pidof $1); 
do 
	mypath="$(readlink /proc/$mypid/exe)\n$mypath"
	mycwd="$(readlink /proc/$mypid/cwd)\n$mycwd"
	#myenv="$(tr -d '\0' </proc/$mypid/environ)\n$myenv"
	myenv="$(tr '\0' ' '</proc/$mypid/environ)\n$myenv"
	mycmdline="$(tr '\0' ' ' </proc/$mypid/cmdline; echo)$mycmdline"
	myulimit="$(tr '\0' '\n' </proc/$mypid/limits)\n$myulimit"
#printf "$myulimit"
done

echo ""
echo "Actual Path:"
printf "$mypath"|uniq
echo ""
echo "Current working directory:"
printf "$mycwd"|uniq
echo ""
echo "Environment for that process:"
printf "$myenv"|uniq
echo ""
echo "command line arguments for that process:"
echo "$mycmdline"|uniq
echo ""
echo "ulimits for that process:"
printf "$myulimit"|sort|uniq
echo ""

