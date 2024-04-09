FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]
#create and activate virtual environment
RUN apt -y update && apt -y upgrade
RUN apt -y install python3
RUN apt -y install python3.10-venv
RUN apt -y install zip unzip
RUN apt -y install wget
RUN apt -y install --fix-missing curl
RUN apt -y install git

#Download codebase
RUN mkdir -p $HOME/Documents/projectaria_sandbox \
&& cd $HOME/Documents/projectaria_sandbox \
&& git clone https://github.com/facebookresearch/projectaria_tools.git -b 1.5.0

#Create virtual environment
RUN python3 -m venv $HOME/projectaria_tools_python_env \
&& source $HOME/projectaria_tools_python_env/bin/activate \
&& pip3 install --upgrade pip \
&& pip3 install projectaria-tools'[all]'

#Download MPS sample dataset
ENV MPS_SAMPLE_PATH=/tmp/mps_sample
ENV BASE_URL="https://www.projectaria.com/async/sample/download/?bucket=mps&filename="
ENV OPTIONS="-C - -O -L"

RUN mkdir -p $MPS_SAMPLE_PATH

RUN curl -o $MPS_SAMPLE_PATH/sample.vrs $OPTIONS "${BASE_URL}sample.vrs" \
&& curl -o $MPS_SAMPLE_PATH/trajectory.zip $OPTIONS "${BASE_URL}trajectory.zip" \
&& curl -o $MPS_SAMPLE_PATH/eye_gaze.zip $OPTIONS "${BASE_URL}eye_gaze.zip" \ 
&& unzip -o $MPS_SAMPLE_PATH/eye_gaze.zip  -d $MPS_SAMPLE_PATH \
&& unzip -o $MPS_SAMPLE_PATH/trajectory.zip -d $MPS_SAMPLE_PATH

#ENV PATH="/opt/venv/bin:$PATH"
#ENTRYPOINT ["python3"]
CMD ["python3"]