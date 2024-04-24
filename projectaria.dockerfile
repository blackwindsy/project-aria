FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]


# install dependencies
RUN apt -y update && apt -y upgrade
RUN apt -y install python3
RUN apt -y install python3.10-venv
RUN apt -y install zip unzip
RUN apt -y install wget
RUN apt -y install --fix-missing curl
RUN apt -y install git
RUN apt -y install pcmanfm lxtask xterm

# dependencies required by rerun: https://www.rerun.io/docs/getting-started/troubleshooting
RUN apt -y install \
    libclang-dev \
    libatk-bridge2.0-0 \
    libfontconfig1-dev \
    libfreetype6-dev \
    libglib2.0-dev \
    libgtk-3-dev \
    libssl-dev \
    libxcb-render0-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    libxkbcommon-dev \
    patchelf
# dependencies required on WSL2
RUN apt -y install \
    libvulkan1 \
    libxcb-randr0 \  
    mesa-vulkan-drivers \
    adwaita-icon-theme-full

# dependencies required by viewer_aria_sensors
RUN apt -y install libxkbcommon-x11-0


# Set environment variable for XWindow display connection info
# host.docker.internal is docker keyword that whould work like DNS name
# If this doesn't work, manually set DISPLAY value to use docker host's IP address
ENV DISPLAY=host.docker.internal:0.0


# Download Aria Tools codebase
RUN mkdir -p $HOME/Documents/projectaria_sandbox \
    && cd $HOME/Documents/projectaria_sandbox \
    && git clone https://github.com/facebookresearch/projectaria_tools.git -b 1.5.0

# Create Python virtual environment
RUN python3 -m venv $HOME/projectaria_tools_python_env \
    && source $HOME/projectaria_tools_python_env/bin/activate \
    && pip3 install --upgrade pip \
    && pip3 install projectaria-tools'[all]'

# Download MPS sample dataset
ENV MPS_SAMPLE_PATH=/tmp/mps_sample
ENV BASE_URL="https://www.projectaria.com/async/sample/download/?bucket=mps&filename="
ENV OPTIONS="-C - -O -L"

RUN mkdir -p $MPS_SAMPLE_PATH
RUN curl -o $MPS_SAMPLE_PATH/sample.vrs $OPTIONS "${BASE_URL}sample.vrs"
RUN curl -o $MPS_SAMPLE_PATH/trajectory.zip $OPTIONS "${BASE_URL}trajectory.zip" \
    && unzip -o $MPS_SAMPLE_PATH/trajectory.zip -d $MPS_SAMPLE_PATH
RUN curl -o $MPS_SAMPLE_PATH/eye_gaze.zip $OPTIONS "${BASE_URL}eye_gaze.zip" \ 
    && unzip -o $MPS_SAMPLE_PATH/eye_gaze.zip  -d $MPS_SAMPLE_PATH

#ENV PATH="/opt/venv/bin:$PATH"
#ENTRYPOINT ["python3"]
CMD ["python3"]