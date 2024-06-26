add_library(${UNION_API_BUILD_TARGET} ${UNION_API_BUILD_TYPE}
        ${UNION_API_SRC_DIR}/union-api/union-api.cpp
        ${UNION_API_SRC_DIR}/union-api/Union/Memory.cpp)

target_include_directories(${UNION_API_BUILD_TARGET}
        PUBLIC $<BUILD_INTERFACE:${UNION_API_SRC_DIR}/union-api>
        PUBLIC $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

target_link_directories(${UNION_API_BUILD_TARGET}
        PUBLIC $<BUILD_INTERFACE:${UNION_API_SRC_DIR}/union-api>
        PUBLIC $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

target_compile_definitions(${UNION_API_BUILD_TARGET}
        PUBLIC WIN32 _CONSOLE
        PUBLIC $<IF:$<STREQUAL:${UNION_API_BUILD_TYPE},SHARED>,_UNION_API_DLL,_UNION_API_LIB>
        PUBLIC $<$<CONFIG:Debug>:_DEBUG:NDEBUG>
        PRIVATE _UNION_API_BUILD)

if(${UNION_API_BUILD_TYPE} STREQUAL "SHARED")
    install(FILES $<TARGET_RUNTIME_DLLS:${UNION_API_BUILD_TARGET}> TYPE BIN)
endif()