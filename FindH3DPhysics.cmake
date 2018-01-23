#=============================================================================
# Copyright 2001-2011 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)
include( H3DUtilityFunctions )
if( MSVC )
  getMSVCPostFix( msvc_postfix )
  set( h3dphysics_name "H3DPhysics${msvc_postfix}" )
elseif( UNIX )
  set( h3dphysics_name h3dphysics )
else()
  set( h3dphysics_name H3DPhysics )
endif()

handleRenamingVariablesBackwardCompatibility( NEW_VARIABLE_NAMES H3DPhysics_LIBRARY_DEBUG
                                              OLD_VARIABLE_NAMES H3DPhysics_DEBUG_LIBRARY
                                              DOC_STRINGS "Path to ${h3dphysics_name}_d library." )

include( H3DCommonFindModuleFunctions )

# Look for the header file.
find_path( H3DPhysics_INCLUDE_DIR NAMES H3D/H3DPhysics/H3DPhysics.h
                                  PATHS ${CONAN_INCLUDE_DIRS_H3DPhysics}
                                  DOC "Path in which the file H3DPhysics/H3DPhysics.h is located." )
mark_as_advanced( H3DPhysics_INCLUDE_DIR )

find_library( H3DPhysics_LIBRARY_RELEASE NAMES ${h3dphysics_name}
                                         PATHS ${CONAN_LIB_DIRS_H3DPhysics}
                                         DOC "Path to ${h3dphysics_name} library." )

find_library( H3DPhysics_LIBRARY_DEBUG NAMES ${h3dphysics_name}_d
                                       PATHS ${CONAN_LIB_DIRS_H3DPhysics}
                                       DOC "Path to ${h3dphysics_name}_d library." )

mark_as_advanced( H3DPhysics_LIBRARY_RELEASE H3DPhysics_LIBRARY_DEBUG )

if( H3DPhysics_INCLUDE_DIR )
  handleComponentsForLib( H3DPhysics
                          MODULE_HEADER_DIRS ${H3DPhysics_INCLUDE_DIR}
                          MODULE_HEADER_SUFFIX /H3D/H3DPhysics/H3DPhysics.h
                          DESIRED ${H3DPhysics_FIND_COMPONENTS}
                          REQUIRED H3DAPI
                          OPTIONAL         ODE      PhysX      PhysX3      HACD      Bullet      SOFA      PythonLibs
                          OPTIONAL_DEFINES HAVE_ODE HAVE_PHYSX HAVE_PHYSX3 HAVE_HACD HAVE_BULLET HAVE_SOFA HAVE_PYTHON
                          OUTPUT found_vars component_libraries component_include_dirs
                          H3D_MODULES H3DAPI )
endif()

include( SelectLibraryConfigurations )
select_library_configurations( H3DPhysics )

include( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set H3DPhysics_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args( H3DPhysics DEFAULT_MSG
                                   H3DPhysics_INCLUDE_DIR H3DPhysics_LIBRARY ${found_vars} )

set( H3DPhysics_LIBRARIES ${H3DPhysics_LIBRARY} ${component_libraries} )
set( H3DPhysics_INCLUDE_DIRS ${H3DPhysics_INCLUDE_DIR} ${component_include_dirs} )
list( REMOVE_DUPLICATES H3DPhysics_INCLUDE_DIRS )

# Backwards compatibility values set here.
set( H3DPhysics_INCLUDE_DIR ${H3DPhysics_INCLUDE_DIRS} )

MESSAGE("** CONAN FOUND H3DPhysics:  ${H3DPhysics_LIBRARIES}")
MESSAGE("** CONAN FOUND H3DPhysics INCLUDE:  ${H3DPhysics_INCLUDE_DIRS}")

# Additional message on MSVC
if( H3DPhysics_FOUND AND MSVC )
  if( NOT H3DPhysics_LIBRARY_RELEASE )
    message( WARNING "H3DPhysics release library not found. Release build might not work properly. To get rid of this warning set H3DPhysics_LIBRARY_RELEASE." )
  endif()
  if( NOT H3DPhysics_LIBRARY_DEBUG )
    message( WARNING "H3DPhysics debug library not found. Debug build might not work properly. To get rid of this warning set H3DPhysics_LIBRARY_DEBUG." )
  endif()
endif()
