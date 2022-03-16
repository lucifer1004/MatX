# ////////////////////////////////////////////////////////////////////////////////
# // BSD 3-Clause License
# //
# // Copyright (c) 2021, NVIDIA Corporation
# // All rights reserved.
# //
# // Redistribution and use in source and binary forms, with or without
# // modification, are permitted provided that the following conditions are met:
# //
# // 1. Redistributions of source code must retain the above copyright notice, this
# //    list of conditions and the following disclaimer.
# //
# // 2. Redistributions in binary form must reproduce the above copyright notice,
# //    this list of conditions and the following disclaimer in the documentation
# //    and/or other materials provided with the distribution.
# //
# // 3. Neither the name of the copyright holder nor the names of its
# //    contributors may be used to endorse or promote products derived from
# //    this software without specific prior written permission.
# //
# // THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# // AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# // IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# // DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# // FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# // DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# // SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# // CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# // OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# // OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# /////////////////////////////////////////////////////////////////////////////////
function(find_and_configure_cutlass VERSION)
    # Strip off "real" from the arch list since CUTLASS doesn't take that
    string(REPLACE "-real" "" CUTLASS_ARCH_LIST ${CMAKE_CUDA_ARCHITECTURES})
    
    # Workaround for CMP0126 in old CMake
    set(CUTLASS_ENABLE_HEADERS_ONLY ON)
    set(CUTLASS_NVCC_ARCHS ${CUTLASS_ARCH_LIST})

    CPMFindPackage(NAME cutlass
        GIT_REPOSITORY  https://github.com/NVIDIA/cutlass.git
        GIT_SHALLOW     TRUE
        GIT_TAG         v${VERSION}
        OPTIONS         "CUTLASS_ENABLE_HEADERS_ONLY ON"
                        "CUTLASS_NVCC_ARCHS ${CUTLASS_ARCH_LIST}")

    if(cutlass_ADDED)
        set(cutlass_SOURCE_DIR ${cutlass_SOURCE_DIR} PARENT_SCOPE)
        set(cutlass_ADDED TRUE PARENT_SCOPE)
    endif()
endfunction()

set(CUDA_MATX_MIN_VERSION_cutlass "2.8.0")
find_and_configure_cutlass(${CUDA_MATX_MIN_VERSION_cutlass})
