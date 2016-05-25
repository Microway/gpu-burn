# Utility for stress-testing NVIDIA GPU accelerators

## gpu-burn will cause GPUs to run *very* hot - Microway disclaims any liability for any damage caused by this tool


### Purpose
This tool thoroughly exercises the math units on NVIDIA GPUs. It is capable of
stressing both the single-precision (32-bit) and double-precision (64-bit) math
units of any GPU with CUDA support. Generally-speaking, this means any NVIDIA
Tesla, Quadro or GeForce GPU released after 2010.

During startup, all GPUs in the system are discovered and tests are run on each.
As the tool runs, the status of each GPU is output (including number of passes,
number of errors encountered, and current GPU temperatures).


### Installation
This tool must be compiled using GCC and NVIDIA CUDA. On most systems, all that
will be necessary is to run `make`. The Makefile does its best to locate all the
necessary dependencies. Once compiled, execute: `./gpu_burn`


### Execution
By default, this utility runs for only a short time. The user must specify how
many seconds the GPU stress test should be run.

To run a single-precision test for one hour, run:
```
gpu_burn $(( 60 * 60 ))
```

To run a double-precision test for one hour, run:
```
gpu_burn -d $(( 60 * 60 ))
```


### More Information
If you would like to purchase professional support for gpu-burn, or to fund
development of a new feature, please visit:
https://www.microway.com/contact/


### Author & Credits
This project is based upon the work of Ville Timonen.
This version of the tool is maintained by Microway, Inc.
