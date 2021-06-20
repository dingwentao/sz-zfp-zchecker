# Dockerfile for SZ, ZFP, and Z-checker

The image can be found and downloaded at [https://hub.docker.com/r/dingwentao/sz-zfp-zchecker](https://hub.docker.com/r/dingwentao/sz-zfp-zchecker). 

## SZ: Error-bounded Scientific Data Lossy Compressor

### Introduction

SZ (v.2.1.11) has been installed in */SZ* directory in this Docker container.

### Quick Start

You can use *sz* binary in */SZ/example* for compression and decompression, for example,

- Compression: *./sz -z -f -c sz.config -i testdata/x86/testfloat_8_8_128.dat -3 8 8 128*

- Decompression: *./sz -x -f -s testdata/x86/testfloat_8_8_128.dat.sz -i testdata/x86/testfloat_8_8_128.dat -3 8 8 128 -a* 

More detailed usage can be found by *./sz -h*.

### Developer

Major Developers: Sheng Di, Dingwen Tao, Xin Liang

Supervisor: Franck Cappello

Other Contributors: Robert Underwood, Sihuan Li, Ali M. Gok, Xiangyu Zou, Tao Lu, Wen Xia, Xuan Wang, Weizhe Zhang

### License

Copyright (c) 2016 by Mathematics and Computer Science (MCS), Argonne National Laboratory.

## ZFP: Library for Compressed numerical Arrays that Support High Throughput Read and Write Random Access

### Introduction

ZFP (v.0.5.5) has been installed in */ZFP* directory in this Docker container.

### Testing

To test that zfp is working properly, type *make test*

or

using CMake *ctest*

### Developer

Peter Lindstrom

### License

Copyright (c) 2014-2019, Lawrence Livermore National Security, LLC. Produced at the Lawrence Livermore National Laboratory.

## Z-checker: Lossy Data Compression Assessment Tool

### Introduction

Z-checker (v.0.6.0) has been installed in */zchecker/Z-checker* directory in this Docker container. Sample data has been put in */usecases* directory.

### Quick Start

You can generate compression results with SZ and ZFP using the following simple steps: 

1. Configure the error bound setting and comparison cases in errBounds.cfg

2. Create a new usecase, by executing "createZCCase.sh [usecase name]". You need to replace [usecase name] by a meaningful name. For example: ./createZCCase.sh Hurricane-data

3. Perform the checking by running the command "runZCCase.sh": ./runZCCase.sh [data type] [error bound mode] [test case name] [data dir] [extension] [dimensions....]. For example: ./runZCCase.sh -f REL Hurricane-data /usecases/Hurricane dat 3600 1800

4. Then, you can find the report PDF generated in /zchecker/Z-checker/[usecase name]/report/

5. Open another terminal and use "docker cp [container ID]:/zchecker/Z-checker/Hurricane-data/report/z-checker-report.pdf [folder path in local host]" to copy the report to your local host. For example: docker cp 8fb43949dfbb:/zchecker/Z-checker/Hurricane-data/report/z-checker-report.pdf /Users/dingwen/Downloads

6. Finally, you should be able to check the Z-checker report PDF in your local host's folder

### Z-checker Online Visualization

1. Go to the directory "/zchecker/Z-checker/build/bin", which contains a pre-buit program executable

2. Run the demo excutable by "mpirun -np 4 heatdis 100 sz.config zc.config temperature sz"

3. Open a browser in the local host, enter "http://localhost:9091", and click "Connect" directly with default host and port

4. Finally, you should be able to see the visualization online for our demo "heat distribution" program

### Developer

Major Developers: Sheng Di, Dingwen Tao, Hanqi Guo

Supervisor: Franck Cappello

### License

Copyright (c) 2017 by Mathematics and Computer Science (MCS), Argonne National Laboratory.
