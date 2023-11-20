FROM haskell:9.4-slim

# install futhark
RUN git clone https://github.com/diku-dk/futhark.git \
    && cd futhark \
    && make configure \
    && make build \
    && make install

# install python 3
RUN apt-get update && apt-get install -y python3 python3-pip libjpeg-dev zlib1g-dev && apt-get clean && rm -rf /var/lib/apt/lists/* && pip3 install --upgrade pip && python3 -m pip install numpy ipython ipykernel matplotlib numba scipy

# install opencl & pyopencl
# RUN apt-get update && apt-get install -y ocl-icd-libopencl1 opencl-headers clinfo && apt-get clean && rm -rf /var/lib/apt/lists/* && mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd  && ln -s /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /usr/lib/libOpenCL.so && python3 -m pip install pyopencl