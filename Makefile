CUDAPATH=/opt/cuda
#CUDAPATH=/usr/local/cuda

# Have this point to an old enough gcc (for nvcc)
GCCPATH=/usr

NVCC=${CUDAPATH}/bin/nvcc
CCPATH=${GCCPATH}/bin


all: gpu_burn_20 gpu_burn_30 gpu_burn_35

compare_20.ptx:
	PATH=.:${CCPATH}:${PATH} ${NVCC} -arch=compute_20 -ptx compare.cu -o compare_20.ptx
	
compare_30.ptx:
	PATH=.:${CCPATH}:${PATH} ${NVCC} -arch=compute_30 -ptx compare.cu -o compare_30.ptx
	
compare_35.ptx:
	PATH=.:${CCPATH}:${PATH} ${NVCC} -arch=compute_35 -ptx compare.cu -o compare_35.ptx

gpu_burn_20: compare_20.ptx gpu_burn-drv.cpp
	g++ -o gpu_burn_20 gpu_burn-drv.cpp -O3 -I${CUDAPATH}/include -lcuda -D COMPARE=\"compare_20.ptx\" -L${CUDAPATH}/lib64 -L${CUDAPATH}/lib -Wl,-rpath=${CUDAPATH}/lib64 -Wl,-rpath=${CUDAPATH}/lib -lcublas -lcudart
	
gpu_burn_30: compare_30.ptx gpu_burn-drv.cpp
	g++ -o gpu_burn_30 gpu_burn-drv.cpp -O3 -I${CUDAPATH}/include -lcuda -D COMPARE=\"compare_30.ptx\" -L${CUDAPATH}/lib64 -L${CUDAPATH}/lib -Wl,-rpath=${CUDAPATH}/lib64 -Wl,-rpath=${CUDAPATH}/lib -lcublas -lcudart
	
gpu_burn_35: compare_35.ptx gpu_burn-drv.cpp
	g++ -o gpu_burn_35 gpu_burn-drv.cpp -O3 -I${CUDAPATH}/include -lcuda -D COMPARE=\"compare_35.ptx\" -L${CUDAPATH}/lib64 -L${CUDAPATH}/lib -Wl,-rpath=${CUDAPATH}/lib64 -Wl,-rpath=${CUDAPATH}/lib -lcublas -lcudart
	

clean:
	rm -f compare_20.ptx compare_30.ptx compare_35.ptx gpu_burn_20 gpu_burn_30 gpu_burn_35
