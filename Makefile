CUDAPATH=/usr/local/cuda
#GCCPATH=/usr/local/gcc-4.4

NVCC=${CUDAPATH}/bin/nvcc
#CCPATH=${GCCPATH}/bin

drv:
	${NVCC} -arch=compute_20 -ptx compare.cu -o compare.ptx
	g++ -Wno-unused-result -g -O3 -I${CUDAPATH}/include -L${CUDAPATH}/lib64 -c -o gpu_burn-drv.o gpu_burn-drv.cpp
	${NVCC} -o gpu_burn -lcuda -lcublas gpu_burn-drv.o

clean:
	/bin/rm -f gpu_burn gpu_burn-drv.o compare.ptx


