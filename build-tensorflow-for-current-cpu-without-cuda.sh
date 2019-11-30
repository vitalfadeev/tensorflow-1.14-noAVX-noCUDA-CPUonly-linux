#!/bin/bash
# Here building Tensorflow.
# - will be created Virtual environment
# - will be downloaded TensorFlow 1.14
# - will be downloaded Bazel 0.26.0
# - will be installed Bazel
# - will be compilled TensorFlow to pip package
# - will be installed pip package into the Virtual environment

##############################################################################
# Warning: Compile time (with CPU Intel B970 2 Core + 10 GB RAM) ~= 20 hours
##############################################################################


# Create venv
python3 -m venv venv

# Activate virtual env
source venv/bin/activate

# Get Temsorflow
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow/

# Set version
git checkout r1.14

# Get Bazel (build system)
wget https://github.com/bazelbuild/bazel/releases/download/0.26.0/bazel-0.26.0-installer-linux-x86_64.sh # bazel installer from https://github.com/bazelbuild/bazel/releases
chmod +x bazel-0.26.0-installer-linux-x86_64.sh

# Install Bazel
sudo ./bazel-0.26.0-installer-linux-x86_64.sh

# Configure Tensorflow
cd tensorflow/
./configure

##################################################################################################
# My answers
##################################################################################################
#WARNING: --batch mode is deprecated. Please instead explicitly shut down your Bazel server using the command "bazel shutdown".
#You have bazel 0.26.0 installed.
#Please specify the location of python. [Default is /home/vital/src/AI/venv/bin/python]:
#
#
#Found possible Python library paths:
#  /home/vital/src/AI/venv/lib/python3.6/site-packages
#Please input the desired Python library path to use.  Default is [/home/vital/src/AI/venv/lib/python3.6/site-packages]
#
#Do you wish to build TensorFlow with XLA JIT support? [Y/n]: n
#No XLA JIT support will be enabled for TensorFlow.
#
#Do you wish to build TensorFlow with OpenCL SYCL support? [y/N]: n
#No OpenCL SYCL support will be enabled for TensorFlow.
#
#Do you wish to build TensorFlow with ROCm support? [y/N]: n
#No ROCm support will be enabled for TensorFlow.
#
#Do you wish to build TensorFlow with CUDA support? [y/N]: n
#No CUDA support will be enabled for TensorFlow.
#
#Do you wish to download a fresh release of clang? (Experimental) [y/N]:
#Clang will not be downloaded.
#
#Do you wish to build TensorFlow with MPI support? [y/N]:
#No MPI support will be enabled for TensorFlow.
#
#Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -march=native -Wno-sign-compare]:
#
#
#Would you like to interactively configure ./WORKSPACE for Android builds? [y/N]:
#Not configuring the WORKSPACE for Android builds.
#
#Preconfigured Bazel build configs. You can use any of the below by adding "--config=<>" to your build command. See .bazelrc for more details.
#	--config=mkl         	# Build with MKL support.
#	--config=monolithic  	# Config for mostly static monolithic build.
#	--config=gdr         	# Build with GDR support.
#	--config=verbs       	# Build with libverbs support.
#	--config=ngraph      	# Build with Intel nGraph support.
#	--config=numa        	# Build with NUMA support.
#	--config=dynamic_kernels	# (Experimental) Build kernels into separate shared objects.
#Preconfigured Bazel build configs to DISABLE default on features:
#	--config=noaws       	# Disable AWS S3 filesystem support.
#	--config=nogcp       	# Disable GCP support.
#	--config=nohdfs      	# Disable HDFS support.
#	--config=noignite    	# Disable Apache Ignite support.
#	--config=nokafka     	# Disable Apache Kafka support.
#	--config=nonccl      	# Disable NVIDIA NCCL support.
#Configuration finished
##################################################################################################


# Build Tensorflow
bazel build --config=opt --config=monolithic //tensorflow/tools/pip_package:build_pip_package

# Build pip package
bazel-bin/tensorflow/tools/pip_package/build_pip_package tensorflow_pkg

# Install pip package
cd tensorflow_pkg
pip3 install tensorflow*.whl

# Done!


# Check 1
python -c "import tensorflow as tf ; print(tf.__version__);"

# You should to see
# 1.14.1

# Check 2
tensorboard

# You shoul to see same message:
# Error: A logdir or db must be specified. For example `tensorboard --logdir mylogdir` or `tensorboard --db sqlite:~/.tensorboard.db`. Run `tensorboard --helpfull` for details and examples.
