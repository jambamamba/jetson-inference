set(OpenCV_FOUND TRUE)
set(ROOT_DIR "/media/isgdev/1885b256-daf3-4ea6-b95b-d4d23af9a578/")
set(OpenCV_DIR "${ROOT_DIR}/openvc")

# set(libcurl_BINARY_DIR "${libcurl_DIR}")
# set(libcurl_INCLUDE_DIR "${libcurl_DIR}/include")
# #set(libcurl_SOURCE_DIR "${CMAKE_SOURCE_DIR}/utils/libcurl")

# if(NOT TARGET curl::curl)
#   add_library(curl::curl SHARED IMPORTED)
#   set_target_properties(curl::curl PROPERTIES
#     IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
#     IMPORTED_LOCATION "${libcurl_LIB}"
#     IMPORTED_IMPLIB "${libcurl_LIB}"
#     INTERFACE_INCLUDE_DIRECTORIES "${libcurl_DIR}/include"
#     INTERFACE_INCLUDE_DIRECTORIES "${libcurl_DIR}/include/include"
#     )

#   target_include_directories(curl::curl INTERFACE
#     $<BUILD_INTERFACE:${libcurl_DIR}/include>
#     $<BUILD_INTERFACE:${libcurl_DIR}/include/include>
#     )
# endif()
