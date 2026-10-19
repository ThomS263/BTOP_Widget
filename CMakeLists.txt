cmake_minimum_required(VERSION 3.16)
project(btop-plasma-widget)

option(INSTALL_PLASMOID "Install the plasmoid for the current user" OFF)
option(PACKAGE_PLASMOID "Create a .plasmoid archive" OFF)

find_package(ECM 6.0.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/package/metadata.json METADATA)
string(JSON PLUGIN_ID GET ${METADATA} KPlugin Id)
string(JSON CUR_VERSION GET ${METADATA} KPlugin Version)

if(INSTALL_PLASMOID)
    find_package(Plasma REQUIRED)
    plasma_install_package(package ${PLUGIN_ID})
endif()

if(PACKAGE_PLASMOID)
    set(PLASMOID_FILE ${CMAKE_CURRENT_SOURCE_DIR}/btop-plasma-widget-v${CUR_VERSION}.plasmoid)
    add_custom_target(plasmoid ALL
        COMMAND ${CMAKE_COMMAND} -E remove -f ${PLASMOID_FILE}
        COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_SOURCE_DIR}/package
                ${CMAKE_COMMAND} -E tar "cfv" ${PLASMOID_FILE} --format=zip .
    )
endif()
