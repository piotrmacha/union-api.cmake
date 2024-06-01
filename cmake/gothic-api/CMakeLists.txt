if(${BUILD_GOTHIC_API})
    add_library(GothicAPI INTERFACE)
    target_include_directories(GothicAPI
            INTERFACE $<BUILD_INTERFACE:${GOTHIC_API_SRC_DIR}>
            $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
            $<BUILD_INTERFACE:${GOTHIC_API_SRC_DIR}ZZenGin/Gothic_UserAPI>
            $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}include/ZenGin/Gothic_UserAPI>)
    target_link_directories(GothicAPI
            INTERFACE $<BUILD_INTERFACE:${GOTHIC_API_SRC_DIR}>
            $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}include>)
    target_sources(GothicAPI
            INTERFACE $<BUILD_INTERFACE:${GOTHIC_API_SRC_DIR}/ZenGin/zGothicAPI.cpp>
            $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}include/ZenGin/zGothicAPI.cpp>)

    list(APPEND GOTHIC_API_TARGETS GothicAPI)
    set(GOTHIC_API_TARGETS ${GOTHIC_API_TARGETS} PARENT_SCOPE)

    install(DIRECTORY ${GOTHIC_API_SRC_DIR}/ZenGin
            DESTINATION include
            FILES_MATCHING REGEX "\.(h|cpp|lib|inl|txt)$")
endif()