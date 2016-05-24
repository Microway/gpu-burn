CUDAPATH=/opt/cuda
#CUDAPATH=/usr/local/cuda-7.5

# Have this point to an old enough gcc (for nvcc)
GCCPATH=/usr

NVCC=${CUDAPATH}/bin/nvcc
CCPATH=${GCCPATH}/bin


all: gpu_burn

NVCCFLAGS=-gencode=arch=compute_20,code=sm_20 -gencode=arch=compute_30,code=sm_30 -gencode=arch=compute_35,code=compute_35 -gencode=arch=compute_37,code=compute_37 -gencode=arch=compute_50,code=sm_50 -gencode=arch=compute_52,code=sm_52 -I. -I/usr/local/cuda/include --fatbin

compare.gpu: compare.cu Makefile
	PATH=.:${CCPATH}:${PATH} ${NVCC} ${NVCCFLAGS} compare.cu -o $@
	
gpu_burn: compare.gpu gpu_burn-drv.cpp
	g++ -o gpu_burn gpu_burn-drv.cpp -O3 -I${CUDAPATH}/include -lcuda -D COMPARE=\"compare.gpu\" -L${CUDAPATH}/lib64 -L${CUDAPATH}/lib -Wl,-rpath=${CUDAPATH}/lib64 -Wl,-rpath=${CUDAPATH}/lib -lcublas -lcudart
	

clean:
	rm -f compare.gpu gpu_burn
