## our modules are without the "lib" prefix

MACRO(ADD_AND_INSTALL_LIBRARY LIBNAME SRCFILES)
	IF(BUILD_STATIC)
		ADD_LIBRARY(${LIBNAME} STATIC ${SRCFILES})
		TARGET_LINK_LIBRARIES(lighttpd2 ${LIBNAME})
	ELSE(BUILD_STATIC)
		ADD_LIBRARY(${LIBNAME} MODULE ${SRCFILES})
		SET(L_INSTALL_TARGETS ${L_INSTALL_TARGETS} ${LIBNAME})

		ADD_TARGET_PROPERTIES(${LIBNAME} LINK_FLAGS ${COMMON_LDFLAGS})
		ADD_TARGET_PROPERTIES(${LIBNAME} COMPILE_FLAGS ${COMMON_CFLAGS})
		SET_TARGET_PROPERTIES(${LIBNAME} PROPERTIES CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")
		TARGET_INCLUDE_DIRECTORIES(${LIBNAME} PRIVATE ${COMMON_INCLUDE_DIRECTORIES})

		TARGET_LINK_LIBRARIES(${LIBNAME} lighttpd-${PACKAGE_VERSION}-common lighttpd-${PACKAGE_VERSION}-shared)

		IF(APPLE)
			SET_TARGET_PROPERTIES(${LIBNAME} PROPERTIES LINK_FLAGS "-flat_namespace -undefined suppress")
		ENDIF(APPLE)
	ENDIF(BUILD_STATIC)
ENDMACRO(ADD_AND_INSTALL_LIBRARY)

MACRO(ADD_TARGET_PROPERTIES _target _name)
	SET(_properties)
	FOREACH(_prop ${ARGN})
		SET(_properties "${_properties} ${_prop}")
	ENDFOREACH(_prop)
	GET_TARGET_PROPERTY(_old_properties ${_target} ${_name})
	#MESSAGE(STATUS "adding property to ${_target} ${_name}:" ${_properties})
	IF(NOT _old_properties)
		# in case it's NOTFOUND
		SET(_old_properties)
	ENDIF(NOT _old_properties)
	SET_TARGET_PROPERTIES(${_target} PROPERTIES ${_name} "${_old_properties} ${_properties}")
ENDMACRO(ADD_TARGET_PROPERTIES)

MACRO(ADD_PREFIX _target _prefix)
	SET(_oldtarget ${${_target}})
	SET(_newtarget)
	FOREACH(_t ${_oldtarget})
		SET(_newtarget ${_newtarget} "${_prefix}${_t}")
	ENDFOREACH(_t)
	SET(${_target} ${_newtarget})
ENDMACRO(ADD_PREFIX)
