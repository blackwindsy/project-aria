# Project Aria
## Executive Summary
Project Aria is to research on the usage of Aria Glasses usage.  This repository is to keep track of the initial set up to participate in the research.

The parent project web site is https://www.projectaria.com/

## Assumption
Development environment has the following.
* OS Windows 11 (a.k.a. local machine, localhost, local Windows machine, or Docker host)
* Your home directory is C:\Users\myaccount
* Aria Tool setup is done within Docker container on Ubuntu.


## Set-up Instructions


1. [Local Windows machine] Clone the GitHub repository under your home directory.  Execute the following in command prompt.

       cd C:\Users\myaccount
       git clone <this_repository_url>	

1. [Local Windows machine] Get IP address of your Windows machine.  Execute the following in command prompt.

       ipconfig

1. [Local Windows machine] Run Xming and make sure it is running as a background process.

1. [Local Windows machine] Open XTerm (X Terminal window) from Xming, and register the local Windows machine's IP address with XHost command.  Replace the IP address value in `docker_host_ip` part.  Execute the following in command prompt (XTerm window).

       xhost docker_host_ip 

1. [Local Windows machine] Run Docker Desktop

1. [Local Windows machine] Build Docker image for Aria Tool.    Execute the following in command prompt.  **NOTE:** Don't miss the ending dot (.) in the build command.

       cd C:\Users\myaccount\project-aria
	   docker image build -t ariatool -f projectaria.dockerfile .

1. [Local Windows machine] Run Docker container for Aria Tool, using the image built in the previous step.  Replace the IP address value in `docker_host_ip` part of DISPLAY environment variable in the command with the value for the local Windows machine.  Execute the following in command prompt.

	   docker container run -it --name ariatool -e DISPLAY=docker_host_ip:0.0 ariatool bash

1. [Ubuntu Docker container] Run Aria Tool.  Execute the following in command prompt.

       cd ~/projectaria_tools_python_env/bin
	   ./viewer_aria_sensors --vrs $MPS_SAMPLE_PATH/sample.vrs

1. [Ubuntu Docker container] If the command above fails with the following error, try setting DISPLAY variable within the container, and try the above command again.  Make sure you specify the correct IP address of the Docker Host.  Execute the following in command prompt.

       export DISPLAY=192.168.1.101


   > **Note:** The following directories within the container should be useful 
   > * Aria Tool local git repository: `~/Documents/projectaria_sandbox` 
   > * Aria Tool Python virtual environment: `~/projectaria_tools_python_env` 
   > * Sample Visualization Data file location: `/tmp/mps_sample` 


1. [Local Windows machine] Xming should receive windowing data from the container, and open a window for it in your local Windows machine.

