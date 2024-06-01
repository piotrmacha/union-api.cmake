set(UNION_API_TARGETS "")
set(GOTHIC_API_TARGETS "")

add_subdirectory(gothic-api)
add_subdirectory(union-api)

if(${BUILD_UNION_API_STATIC} OR ${BUILD_UNION_API_SHARED} OR ${BUILD_GOTHIC_API})
    if(${BUILD_UNION_API_STATIC} OR ${BUILD_UNION_API_SHARED})
        install(DIRECTORY ${UNION_API_SRC_DIR}/union-api/Union
                DESTINATION include
                FILES_MATCHING PATTERN "*.h")
        install(DIRECTORY ${UNION_API_SRC_DIR}/union-api/Libs
                DESTINATION include)
    endif()


    include(CMakePackageConfigHelpers)
    write_basic_package_version_file(
            "${PROJECT_BINARY_DIR}/UnionAPIConfigVersion.cmake"
            VERSION ${PROJECT_VERSION}
            COMPATIBILITY AnyNewerVersion)

    configure_package_config_file(
            "${PROJECT_SOURCE_DIR}/cmake/UnionAPIConfig.cmake.in"
            "${PROJECT_BINARY_DIR}/UnionAPIConfig.cmake"
            INSTALL_DESTINATION lib/cmake/UnionAPI)

    install(FILES
            "${PROJECT_BINARY_DIR}/UnionAPIConfigVersion.cmake"
            "${PROJECT_BINARY_DIR}/UnionAPIConfig.cmake"
            DESTINATION lib/cmake/UnionAPI)

    set(BUILD_TARGETS_EXPORTS "")
    list(APPEND CMAKE_CONFIGURATION_TYPES ${CMAKE_BUILD_TYPE})
    list(REMOVE_DUPLICATES CMAKE_CONFIGURATION_TYPES)

    foreach(BUILD_CONFIG IN ITEMS ${CMAKE_CONFIGURATION_TYPES})
        message(STATUS ${BUILD_CONFIG})
        install(TARGETS ${UNION_API_TARGETS}
                CONFIGURATIONS ${BUILD_CONFIG}
                EXPORT UnionAPITargets-${BUILD_CONFIG}
                LIBRARY DESTINATION lib/${BUILD_CONFIG}
                ARCHIVE DESTINATION lib/${BUILD_CONFIG}
                RUNTIME DESTINATION bin/${BUILD_CONFIG}
                PUBLIC_HEADER DESTINATION include
                INCLUDES DESTINATION include)
        list(APPEND BUILD_TARGETS_EXPORTS UnionAPITargets-${BUILD_CONFIG})

        install(EXPORT UnionAPITargets-${BUILD_CONFIG}
                CONFIGURATIONS ${CMAKE_CONFIGURATION_TYPES}
                FILE UnionAPITargets-${BUILD_CONFIG}.cmake
                NAMESPACE UnionAPI::
                DESTINATION lib/cmake/UnionAPI)
    endforeach()

    install(TARGETS ${GOTHIC_API_TARGETS}
            CONFIGURATIONS ${CMAKE_CONFIGURATION_TYPES}
            EXPORT GothicAPITargets
            PUBLIC_HEADER DESTINATION include
            INCLUDES DESTINATION include)
    list(APPEND BUILD_TARGETS_EXPORTS GothicAPITargets)

    install(EXPORT GothicAPITargets
            CONFIGURATIONS ${CMAKE_CONFIGURATION_TYPES}
            FILE GothicAPITargets.cmake
            NAMESPACE UnionAPI::
            DESTINATION lib/cmake/UnionAPI)
endif()