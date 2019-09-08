#!/bin/bash
cd /usr/src/app/edgecep
rm -r edgecep-python
wget https://github.com/sunya-ch/edgecep_test_public_model/raw/master/edgecep-python-unstable.zip
unzip edgecep-python-unstable.zip
rm -r edgecep-python-unstable.zip
