# Install script for directory: /home/chouer/workspace/rospace/elfin_robot/src/elfin_robot-kinetic-devel/elfin_basic_api

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/chouer/workspace/rospace/elfin_robot/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/elfin_basic_api" TYPE FILE FILES "/home/chouer/workspace/rospace/elfin_robot/devel/include/elfin_basic_api/ElfinBasicAPIDynamicReconfigureConfig.h")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python2.7/dist-packages/elfin_basic_api" TYPE FILE FILES "/home/chouer/workspace/rospace/elfin_robot/devel/lib/python2.7/dist-packages/elfin_basic_api/__init__.py")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  execute_process(COMMAND "/usr/bin/python" -m compileall "/home/chouer/workspace/rospace/elfin_robot/devel/lib/python2.7/dist-packages/elfin_basic_api/cfg")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python2.7/dist-packages/elfin_basic_api" TYPE DIRECTORY FILES "/home/chouer/workspace/rospace/elfin_robot/devel/lib/python2.7/dist-packages/elfin_basic_api/cfg")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/chouer/workspace/rospace/elfin_robot/build/elfin_robot-kinetic-devel/elfin_basic_api/catkin_generated/installspace/elfin_basic_api.pc")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/elfin_basic_api/cmake" TYPE FILE FILES
    "/home/chouer/workspace/rospace/elfin_robot/build/elfin_robot-kinetic-devel/elfin_basic_api/catkin_generated/installspace/elfin_basic_apiConfig.cmake"
    "/home/chouer/workspace/rospace/elfin_robot/build/elfin_robot-kinetic-devel/elfin_basic_api/catkin_generated/installspace/elfin_basic_apiConfig-version.cmake"
    )
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/elfin_basic_api" TYPE FILE FILES "/home/chouer/workspace/rospace/elfin_robot/src/elfin_robot-kinetic-devel/elfin_basic_api/package.xml")
endif()

