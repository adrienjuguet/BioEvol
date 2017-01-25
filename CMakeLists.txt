cmake_minimum_required(VERSION 2.8)
project(pdc_evol_model)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules" ${CMAKE_MODULE_PATH})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g -O3 -fopenmp")

set(SOURCE_FILES main.cpp src/World.cpp src/World.h src/GridCell.cpp src/GridCell.h src/Organism.cpp src/Organism.h src/DNA.cpp src/DNA.h src/BP.cpp src/BP.h src/BP_Protein_Block.cpp src/BP_Protein_Block.h src/BP_Protein.cpp src/BP_Protein.h src/BP_Pump_Block.cpp src/BP_Pump_Block.h src/BP_Pump.cpp src/BP_Pump.h src/BP_Move_Block.cpp src/BP_Move_Block.h src/BP_Move.cpp src/BP_Move.h src/RNA.cpp src/RNA.h src/Protein.cpp src/Protein.h src/Move.cpp src/Move.h src/Pump.cpp src/Pump.h src/Common.cpp src/Common.h)
find_package(CUDA)

#set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -std=c++11) #Grid5000
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS})

cuda_compile(CUDA_O src/Cuda.cu OPTIONS -D_FORCE_INLINES )

add_executable(pdc_evol_model ${SOURCE_FILES} ${CUDA_O})

find_package(ZLIB REQUIRED)
if(ZLIB_FOUND)
    include_directories(${ZLIB_INCLUDE_DIR})
    target_link_libraries(pdc_evol_model ${ZLIB_LIBRARIES})
endif(ZLIB_FOUND)

#target_link_libraries(pdc_evol_model /usr/local/cuda/lib64/libcudart.so) #Grid5000
target_link_libraries(pdc_evol_model -lcudart)
