# If the CUDA environment variables are already set, use them
ifeq ($(CUDA_HOME), )
	# If the above did not find anything, then use the default path to
	# NVIDIA CUDA (typically installed into /usr/local/cuda)
	# If none of the above worked, try some other common paths
	ifneq ($(wildcard /usr/local/cuda), )
		CUDA_PATH=/usr/local/cuda
	else ifneq ($(wildcard /usr/local/cuda-9.1),)
		CUDA_PATH=/usr/local/cuda-9.1
	else ifneq ($(wildcard /usr/local/cuda-9.0),)
		CUDA_PATH=/usr/local/cuda-9.0
	else ifneq ($(wildcard /usr/local/cuda-8.0),)
		CUDA_PATH=/usr/local/cuda-8.0
	else ifneq ($(wildcard /usr/local/cuda-7.5),)
		CUDA_PATH=/usr/local/cuda-7.5
	else ifneq ($(wildcard /usr/local/cuda-7.0),)
		CUDA_PATH=/usr/local/cuda-7.0
	else ifneq ($(wildcard /usr/local/cuda-6.5),)
		CUDA_PATH=/usr/local/cuda-6.5
	else ifneq ($(wildcard /opt/cuda),)
		CUDA_PATH=/opt/cuda
	endif
else
	CUDA_PATH=$(CUDA_HOME)
endif


# Have this point to an old enough gcc (for nvcc)
GCCPATH=/usr

NVCC=${CUDA_PATH}/bin/nvcc
CCPATH=${GCCPATH}/bin
CUDA_VER_MAJOR=$(shell cat ${CUDA_PATH}/version.txt | sed -e 's/CUDA Version //' | cut -c 1)

ifeq ($(shell expr ${CUDA_VER_MAJOR} \>= 9), 1)
	NVCCFLAGS=-gencode=arch=compute_30,code=sm_30 -gencode=arch=compute_35,code=compute_35 -gencode=arch=compute_37,code=compute_37 -gencode=arch=compute_50,code=sm_50 -gencode=arch=compute_52,code=sm_52 -I. -I${CUDA_PATH}/include --fatbin
else
	NVCCFLAGS=-gencode=arch=compute_20,code=sm_20 -gencode=arch=compute_30,code=sm_30 -gencode=arch=compute_35,code=compute_35 -gencode=arch=compute_37,code=compute_37 -gencode=arch=compute_50,code=sm_50 -gencode=arch=compute_52,code=sm_52 -I. -I${CUDA_PATH}/include --fatbin
endif

all: gpu_burn

gpu_burn.cuda_kernel: compare.cu Makefile
	PATH=.:${CCPATH}:${PATH} ${NVCC} ${NVCCFLAGS} compare.cu -o $@

gpu_burn: gpu_burn.cuda_kernel gpu_burn-drv.cpp
	g++ -o gpu_burn gpu_burn-drv.cpp -O3 -I${CUDA_PATH}/include -lcuda -L${CUDA_PATH}/lib64 -L${CUDA_PATH}/lib -Wl,-rpath=${CUDA_PATH}/lib64 -Wl,-rpath=${CUDA_PATH}/lib -lcublas -lcudart


clean:
	rm -f gpu_burn.cuda_kernel gpu_burn
