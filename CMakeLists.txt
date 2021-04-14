cmake_minimum_required(VERSION 3.6)
project(cuda_ws)

# For CUDA
find_package(CUDA REQUIRED)
if (CUDA_FOUND)
    message("Cuda version: " ${CUDA_VERSION})
    CUDA_ADD_EXECUTABLE(cuda_ws
            main.cu
            )
endif ()