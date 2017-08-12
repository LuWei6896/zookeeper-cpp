include(CMakeParseArguments)

# configuration_setting
# Creates a configuration setting, which is configurable via a CMake option. If the option is set to anything
# non-default, a macro with the name `ZKPP_${NAME}_USE_${OPTION_VALUE}` is exported as `1`.
#
#  - NAME: The name of the configuration setting.
#  - DOC: Documentation to place in the CMake configuration GUI.
#  - DEFUALT: The default value of the configuration setting (some value from OPTIONS). This value must be synced with
#    the C++ code or the behavior will be nonsense.
#  - OPTIONS[]: List of valid options to set.
function(configuration_setting)
  set(options)
  set(oneValueArgs NAME DOC DEFAULT)
  set(multiValueArgs OPTIONS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  set(ZKPP_BUILD_SETTING_${ARG_NAME} "${ARG_DEFAULT}"
      CACHE STRING "${ARG_DOC}"
     )
  if(NOT ${ZKPP_BUILD_SETTING_${ARG_NAME}} IN_LIST ARG_OPTIONS)
    message(SEND_ERROR "Invalid setting for ${ARG_NAME}: ${ZKPP_BUILD_SETTING_${ARG_NAME}}")
  endif()

  if(NOT ${ZKPP_BUILD_SETTING_${ARG_NAME}} STREQUAL ${ARG_DEFAULT})
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DZKPP_${ARG_NAME}_USE_${ZKPP_BUILD_SETTING_${ARG_NAME}}=1" PARENT_SCOPE)
  endif()

  message(STATUS "  ${ARG_NAME}: ${ZKPP_BUILD_SETTING_${ARG_NAME}}")
endfunction()
