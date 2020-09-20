cmake_minimum_required(VERSION 3.11 FATAL_ERROR)

include(FindPackageHandleStandardArgs)

set(FLATBUFFERS_VERSION 1.12.0)

find_program(
  FLATBUFFERS_FLATC_EXECUTABLE
  NAMES flatc
  PATHS ENV FLATBUFFERS_DIR
)

if(DEFINED FLATBUFFERS_FLATC_EXECUTABLE)
  execute_process(
    COMMAND ${FLATBUFFERS_FLATC_EXECUTABLE} "--version"
    OUTPUT_VARIABLE _FLATBUFFERS_FLATC_VERSION_OUTPUT
    ERROR_VARIABLE _FLATBUFFERS_FLATC_VERSION_ERROR
    RESULT_VARIABLE _FLATBUFFERS_FLATC_VERSION_RESULT
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_STRIP_TRAILING_WHITESPACE
  )

  if(NOT "${_FLATBUFFERS_FLATC_VERSION_RESULT}" EQUAL "0")
    if(${Flatbuffers_FIND_REQUIRED})
      message(FATAL_ERROR "flatc executable failed to execute properly, exit status '${_FLATBUFFERS_FLATC_VERSION_RESULT}' / error message '${_FLATBUFFERS_FLATC_VERSION_ERROR}'")
    endif()

    unset(FLATBUFFERS_FLATC_EXECUTABLE)
    set(FLATBUFFERS_FOUND FALSE)
    return()

  endif()

  if(NOT "${_FLATBUFFERS_FLATC_VERSION_OUTPUT}" MATCHES "^flatc version [0-9]+\.[0-9]+\.[0-9]+[\\n\\t ]*$")

    if(${Flatbuffers_FIND_REQUIRED})
      message(FATAL_ERROR "flatc executable at '${FLATBUFFERS_FLATC_EXECUTABLE}' version output not recognised: '${_FLATBUFFERS_FLATC_VERSION_OUTPUT}'")
    endif()

    unset(FLATBUFFERS_FLATC_EXECUTABLE)
    set(FLATBUFFERS_FOUND FALSE)
    return()

  else()
    string(REGEX REPLACE "^flatc version ([0-9]+\.[0-9]+\.[0-9]+\.)[\\n\\t ]*$" "\\1" FLATBUFFERS_VERSION ${_FLATBUFFERS_FLATC_VERSION_OUTPUT})
  endif()
endif()

find_path(
  FLATBUFFERS_INCLUDE_DIRS
  flatbuffers/flatbuffers.h
  PATHS ENV FLATBUFFERS_DIR
)

find_library(
  FLATBUFFERS_LIBRARIES 
  NAMES flatbuffers
  PATHS ENV FLATBUFFERS_DIR
)

find_package_handle_standard_args(
  Flatbuffers
  REQUIRED_VARS
    FLATBUFFERS_FLATC_EXECUTABLE
    FLATBUFFERS_INCLUDE_DIRS
    FLATBUFFERS_LIBRARIES
)
