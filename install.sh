#!/bin/bash

# conda config --add channels rpi
# conda install python=3.5 --yes
# conda create --name env python=3.5 --yes

helpFunction()
{
   echo ""
   echo "Usage: $0 -l location -n name"
   echo -e "\t-l device location"
   echo -e "\t-n device identifier"
   exit 1 # Exit script after printing help
}

while getopts l:n:h opt
do
   case "$opt" in
      l) location="$OPTARG" ;;
      n) name="$OPTARG" ;;
      h) helpFunction ;;
      ?) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

echo $location;
echo $name;

# Print helpFunction in case parameters are empty
if [ -z "$location" ] || [ -z "$name" ]
then
   echo "Some arguements are missing.";
   helpFunction
fi

mkdir /usr/src/app
cd /usr/src/app
wget https://github.com/sunya-ch/edgecep_test_public_model/blob/master/rasp_edge.zip
unzip rasp_edge.zip
rm -r rasp_edge.zip
cd rasp_edge
mv edgecep_service.service /etc/systemd/system

echo "export BALENA_DEVICE_UUID=$name" >> ~/.bashrc
echo "export LOCATION=$location" >> ~/.bashrc
echo "source activate env" >> ~/.bashrc
source ~/.bashrc

conda install cython --yes
conda install numpy --yes
conda install pandas --yes
conda install statsmodels --yes
conda install scikit-learn --yes
conda install opencv --yes

pip install https://github.com/lhelontra/tensorflow-on-arm/releases/download/v1.14.0/tensorflow-1.14.0-cp35-none-linux_armv7l.whl
pip install tensorflow-hub
pip install pynverse

pip install Pillow
pip install imageio pysmb netifaces requests psutil

# Install Redis.
apt-get install -y redis-server
redis-server /etc/redis/redis.conf
sh -c "echo \"127.0.0.1       redis_db\" >> /etc/hosts"

# Install program
cd /usr/src/app/edgecep

wget https://github.com/sunya-ch/edgecep_test_public_model/raw/master/edgecep_python-unstable.zip
unzip edgecep-python-unstable.zip
rm -r edgecep-python-unstable.zip
cd edgecep_python
pip install -r requirement.txt

systemctl enable edgecep
