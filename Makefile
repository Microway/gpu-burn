# If the CUDA environment variables are already set, use them
CUDA_PATH?=${CUDA_HOME}

# If the above did not find anything, then use the default path to
# NVIDIA CUDA (typically installed into /usr/local/cuda)
CUDA_PATH?=/usr/local/cuda

# If none of the above worked, try some other common paths
ifneq ("$(wildcard $(CUDA_PATH))","")
# The default PATH is good - nothing else to do
else ifneq ("$(wildcard /usr/local/cuda-9.0)","")
CUDA_PATH=/usr/local/cuda-9.0
else ifneq ("$(wildcard /usr/local/cuda-8.0)","")
CUDA_PATH=/usr/local/cuda-8.0
else ifneq ("$(wildcard /usr/local/cuda-7.5)","")
CUDA_PATH=/usr/local/cuda-7.5
else ifneq ("$(wildcard /usr/local/cuda-7.0)","")
CUDA_PATH=/usr/local/cuda-7.0
else ifneq ("$(wildcard /usr/local/cuda-6.5)","")
CUDA_PATH=/usr/local/cuda-6.5
else ifneq ("$(wildcard /opt/cuda)","")
CUDA_PATH=/opt/cuda
endif


# Have this point to an old enough gcc (for nvcc)
GCCPATH=/usr

NVCC=${CUDA_PATH}/bin/nvcc
CCPATH=${GCCPATH}/bin


all: gpu_burn

NVCCFLAGS=-gencode=arch=compute_20,code=sm_20 -gencode=arch=compute_30,code=sm_30 -gencode=arch=compute_35,code=compute_35 -gencode=arch=compute_37,code=compute_37 -gencode=arch=compute_50,code=sm_50 -gencode=arch=compute_52,code=sm_52 -I. -I${CUDA_PATH}/include --fatbin

gpu_burn.cuda_kernel: compare.cu Makefile
	PATH=.:${CCPATH}:${PATH} ${NVCC} ${NVCCFLAGS} compare.cu -o $@

gpu_burn: gpu_burn.cuda_kernel gpu_burn-drv.cpp
	g++ -o gpu_burn gpu_burn-drv.cpp -O3 -I${CUDA_PATH}/include -lcuda -L${CUDA_PATH}/lib64 -L${CUDA_PATH}/lib -Wl,-rpath=${CUDA_PATH}/lib64 -Wl,-rpath=${CUDA_PATH}/lib -lcublas -lcudart


clean:
	rm -f gpu_burn.cuda_kernel gpu_burn
