-- Copyright 2006-2016 Mitchell mitchell.att.foicica.com. See LICENSE.
-- CMake LPeg lexer.

local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'cmake'}

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- Comments.
local comment = token(l.COMMENT, '#' * l.nonnewline^0)

-- Strings.
local string = token(l.STRING, l.delimited_range('"'))

-- Keywords.
local keyword = token(l.KEYWORD, word_match({
  'IF', 'ENDIF', 'FOREACH', 'ENDFOREACH', 'WHILE', 'ENDWHILE', 'ELSE', 'ELSEIF'
}, nil, true))

-- Commands.
local command = token(l.FUNCTION, word_match({
  'ADD_CUSTOM_COMMAND', 'ADD_CUSTOM_TARGET', 'ADD_DEFINITIONS',
  'ADD_DEPENDENCIES', 'ADD_EXECUTABLE', 'ADD_LIBRARY', 'ADD_SUBDIRECTORY',
  'ADD_TEST', 'AUX_SOURCE_DIRECTORY', 'BUILD_COMMAND', 'BUILD_NAME',
  'CMAKE_MINIMUM_REQUIRED', 'CONFIGURE_FILE', 'CREATE_TEST_SOURCELIST',
  'ENABLE_LANGUAGE', 'ENABLE_TESTING', 'ENDMACRO', 'EXECUTE_PROCESS',
  'EXEC_PROGRAM', 'EXPORT_LIBRARY_DEPENDENCIES', 'FILE', 'FIND_FILE',
  'FIND_LIBRARY', 'FIND_PACKAGE', 'FIND_PATH', 'FIND_PROGRAM', 'FLTK_WRAP_UI',
  'GET_CMAKE_PROPERTY', 'GET_DIRECTORY_PROPERTY', 'GET_FILENAME_COMPONENT',
  'GET_SOURCE_FILE_PROPERTY', 'GET_TARGET_PROPERTY', 'GET_TEST_PROPERTY',
  'INCLUDE', 'INCLUDE_DIRECTORIES', 'INCLUDE_EXTERNAL_MSPROJECT',
  'INCLUDE_REGULAR_EXPRESSION', 'INSTALL', 'INSTALL_FILES', 'INSTALL_PROGRAMS',
  'INSTALL_TARGETS', 'LINK_DIRECTORIES', 'LINK_LIBRARIES', 'LIST', 'LOAD_CACHE',
  'LOAD_COMMAND', 'MACRO', 'MAKE_DIRECTORY', 'MARK_AS_ADVANCED', 'MATH',
  'MESSAGE', 'OPTION', 'OUTPUT_REQUIRED_FILES', 'PROJECT', 'QT_WRAP_CPP',
  'QT_WRAP_UI', 'REMOVE', 'REMOVE_DEFINITIONS', 'SEPARATE_ARGUMENTS', 'SET',
  'SET_DIRECTORY_PROPERTIES', 'SET_SOURCE_FILES_PROPERTIES',
  'SET_TARGET_PROPERTIES', 'SET_TESTS_PROPERTIES', 'SITE_NAME', 'SOURCE_GROUP',
  'STRING', 'SUBDIRS', 'SUBDIR_DEPENDS', 'TARGET_LINK_LIBRARIES', 'TRY_COMPILE',
  'TRY_RUN', 'USE_MANGLED_MESA', 'UTILITY_SOURCE', 'VARIABLE_REQUIRES',
  'VTK_MAKE_INSTANTIATOR', 'VTK_WRAP_JAVA', 'VTK_WRAP_PYTHON', 'VTK_WRAP_TCL',
  'WRITE_FILE',
}, nil, true))

-- Constants.
local constant = token(l.CONSTANT, word_match({
  'BOOL', 'CACHE', 'FALSE', 'N', 'NO', 'ON', 'OFF', 'NOTFOUND', 'TRUE'
}, nil, true))

-- Variables.
local variable = token(l.VARIABLE, word_match{
  'APPLE', 'BORLAND', 'CMAKE_AR', 'CMAKE_BACKWARDS_COMPATIBILITY',
  'CMAKE_BASE_NAME', 'CMAKE_BINARY_DIR', 'CMAKE_BUILD_TOOL', 'CMAKE_BUILD_TYPE',
  'CMAKE_CACHEFILE_DIR', 'CMAKE_CACHE_MAJOR_VERSION',
  'CMAKE_CACHE_MINOR_VERSION', 'CMAKE_CACHE_RELEASE_VERSION',
  'CMAKE_CFG_INTDIR', 'CMAKE_COLOR_MAKEFILE', 'CMAKE_COMMAND',
  'CMAKE_COMPILER_IS_GNUCC', 'CMAKE_COMPILER_IS_GNUCC_RUN',
  'CMAKE_COMPILER_IS_GNUCXX', 'CMAKE_COMPILER_IS_GNUCXX_RUN',
  'CMAKE_CTEST_COMMAND', 'CMAKE_CURRENT_BINARY_DIR', 'CMAKE_CURRENT_SOURCE_DIR',
  'CMAKE_CXX_COMPILER', 'CMAKE_CXX_COMPILER_ARG1', 'CMAKE_CXX_COMPILER_ENV_VAR',
  'CMAKE_CXX_COMPILER_FULLPATH', 'CMAKE_CXX_COMPILER_LOADED',
  'CMAKE_CXX_COMPILER_WORKS', 'CMAKE_CXX_COMPILE_OBJECT',
  'CMAKE_CXX_CREATE_SHARED_LIBRARY',
  'CMAKE_CXX_CREATE_SHARED_LIBRARY_FORBIDDEN_FLAGS',
  'CMAKE_CXX_CREATE_SHARED_MODULE', 'CMAKE_CXX_CREATE_STATIC_LIBRARY',
  'CMAKE_CXX_FLAGS', 'CMAKE_CXX_FLAGS_DEBUG', 'CMAKE_CXX_FLAGS_DEBUG_INIT',
  'CMAKE_CXX_FLAGS_INIT', 'CMAKE_CXX_FLAGS_MINSIZEREL',
  'CMAKE_CXX_FLAGS_MINSIZEREL_INIT', 'CMAKE_CXX_FLAGS_RELEASE',
  'CMAKE_CXX_FLAGS_RELEASE_INIT', 'CMAKE_CXX_FLAGS_RELWITHDEBINFO',
  'CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT', 'CMAKE_CXX_IGNORE_EXTENSIONS',
  'CMAKE_CXX_INFORMATION_LOADED', 'CMAKE_CXX_LINKER_PREFERENCE',
  'CMAKE_CXX_LINK_EXECUTABLE', 'CMAKE_CXX_LINK_FLAGS',
  'CMAKE_CXX_OUTPUT_EXTENSION', 'CMAKE_CXX_SOURCE_FILE_EXTENSIONS',
  'CMAKE_C_COMPILER', 'CMAKE_C_COMPILER_ARG1', 'CMAKE_C_COMPILER_ENV_VAR',
  'CMAKE_C_COMPILER_FULLPATH', 'CMAKE_C_COMPILER_LOADED',
  'CMAKE_C_COMPILER_WORKS', 'CMAKE_C_COMPILE_OBJECT',
  'CMAKE_C_CREATE_SHARED_LIBRARY',
  'CMAKE_C_CREATE_SHARED_LIBRARY_FORBIDDEN_FLAGS',
  'CMAKE_C_CREATE_SHARED_MODULE', 'CMAKE_C_CREATE_STATIC_LIBRARY',
  'CMAKE_C_FLAGS', 'CMAKE_C_FLAGS_DEBUG', 'CMAKE_C_FLAGS_DEBUG_INIT',
  'CMAKE_C_FLAGS_INIT', 'CMAKE_C_FLAGS_MINSIZEREL',
  'CMAKE_C_FLAGS_MINSIZEREL_INIT', 'CMAKE_C_FLAGS_RELEASE',
  'CMAKE_C_FLAGS_RELEASE_INIT', 'CMAKE_C_FLAGS_RELWITHDEBINFO',
  'CMAKE_C_FLAGS_RELWITHDEBINFO_INIT', 'CMAKE_C_IGNORE_EXTENSIONS',
  'CMAKE_C_INFORMATION_LOADED', 'CMAKE_C_LINKER_PREFERENCE',
  'CMAKE_C_LINK_EXECUTABLE', 'CMAKE_C_LINK_FLAGS', 'CMAKE_C_OUTPUT_EXTENSION',
  'CMAKE_C_SOURCE_FILE_EXTENSIONS', 'CMAKE_DL_LIBS', 'CMAKE_EDIT_COMMAND',
  'CMAKE_EXECUTABLE_SUFFIX', 'CMAKE_EXE_LINKER_FLAGS',
  'CMAKE_EXE_LINKER_FLAGS_DEBUG', 'CMAKE_EXE_LINKER_FLAGS_MINSIZEREL',
  'CMAKE_EXE_LINKER_FLAGS_RELEASE', 'CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO',
  'CMAKE_FILES_DIRECTORY', 'CMAKE_FIND_APPBUNDLE', 'CMAKE_FIND_FRAMEWORK',
  'CMAKE_FIND_LIBRARY_PREFIXES', 'CMAKE_FIND_LIBRARY_SUFFIXES',
  'CMAKE_GENERATOR', 'CMAKE_HOME_DIRECTORY', 'CMAKE_INCLUDE_FLAG_C',
  'CMAKE_INCLUDE_FLAG_CXX', 'CMAKE_INCLUDE_FLAG_C_SEP', 'CMAKE_INIT_VALUE',
  'CMAKE_INSTALL_PREFIX', 'CMAKE_LIBRARY_PATH_FLAG', 'CMAKE_LINK_LIBRARY_FLAG',
  'CMAKE_LINK_LIBRARY_SUFFIX', 'CMAKE_MAJOR_VERSION', 'CMAKE_MAKE_PROGRAM',
  'CMAKE_MINOR_VERSION', 'CMAKE_MODULE_EXISTS', 'CMAKE_MODULE_LINKER_FLAGS',
  'CMAKE_MODULE_LINKER_FLAGS_DEBUG', 'CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL',
  'CMAKE_MODULE_LINKER_FLAGS_RELEASE',
  'CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO',
  'CMAKE_MacOSX_Content_COMPILE_OBJECT', 'CMAKE_NUMBER_OF_LOCAL_GENERATORS',
  'CMAKE_OSX_ARCHITECTURES', 'CMAKE_OSX_SYSROOT', 'CMAKE_PARENT_LIST_FILE',
  'CMAKE_PATCH_VERSION', 'CMAKE_PLATFORM_HAS_INSTALLNAME',
  'CMAKE_PLATFORM_IMPLICIT_INCLUDE_DIRECTORIES', 'CMAKE_PLATFORM_ROOT_BIN',
  'CMAKE_PROJECT_NAME', 'CMAKE_RANLIB', 'CMAKE_ROOT',
  'CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS',
  'CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS',
  'CMAKE_SHARED_LIBRARY_CXX_FLAGS', 'CMAKE_SHARED_LIBRARY_C_FLAGS',
  'CMAKE_SHARED_LIBRARY_LINK_C_FLAGS', 'CMAKE_SHARED_LIBRARY_PREFIX',
  'CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG',
  'CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP',
  'CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG', 'CMAKE_SHARED_LIBRARY_SONAME_C_FLAG',
  'CMAKE_SHARED_LIBRARY_SUFFIX', 'CMAKE_SHARED_LINKER_FLAGS',
  'CMAKE_SHARED_LINKER_FLAGS_DEBUG', 'CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL',
  'CMAKE_SHARED_LINKER_FLAGS_RELEASE',
  'CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO',
  'CMAKE_SHARED_MODULE_CREATE_CXX_FLAGS', 'CMAKE_SHARED_MODULE_CREATE_C_FLAGS',
  'CMAKE_SHARED_MODULE_PREFIX', 'CMAKE_SHARED_MODULE_SUFFIX',
  'CMAKE_SIZEOF_VOID_P', 'CMAKE_SKIP_RPATH', 'CMAKE_SOURCE_DIR',
  'CMAKE_STATIC_LIBRARY_PREFIX', 'CMAKE_STATIC_LIBRARY_SUFFIX', 'CMAKE_SYSTEM',
  'CMAKE_SYSTEM_AND_CXX_COMPILER_INFO_FILE',
  'CMAKE_SYSTEM_AND_C_COMPILER_INFO_FILE', 'CMAKE_SYSTEM_APPBUNDLE_PATH',
  'CMAKE_SYSTEM_FRAMEWORK_PATH', 'CMAKE_SYSTEM_INCLUDE_PATH',
  'CMAKE_SYSTEM_INFO_FILE', 'CMAKE_SYSTEM_LIBRARY_PATH', 'CMAKE_SYSTEM_LOADED',
  'CMAKE_SYSTEM_NAME', 'CMAKE_SYSTEM_PROCESSOR', 'CMAKE_SYSTEM_PROGRAM_PATH',
  'CMAKE_SYSTEM_SPECIFIC_INFORMATION_LOADED', 'CMAKE_SYSTEM_VERSION',
  'CMAKE_UNAME', 'CMAKE_USE_RELATIVE_PATHS', 'CMAKE_VERBOSE_MAKEFILE', 'CYGWIN',
  'EXECUTABLE_OUTPUT_PATH', 'FORCE', 'HAVE_CMAKE_SIZEOF_VOID_P',
  'LIBRARY_OUTPUT_PATH', 'MACOSX_BUNDLE', 'MINGW', 'MSVC60', 'MSVC70', 'MSVC71',
  'MSVC80', 'MSVC', 'MSVC_IDE', 'PROJECT_BINARY_DIR', 'PROJECT_NAME',
  'PROJECT_SOURCE_DIR', 'PROJECT_BINARY_DIR', 'PROJECT_SOURCE_DIR',
  'RUN_CONFIGURE', 'UNIX', 'WIN32', '_CMAKE_OSX_MACHINE',
  -- More variables.
  'LOCATION', 'TARGET', 'POST_BUILD', 'PRE_BUILD', 'ARGS'
} + P('$') * l.delimited_range('{}', false, true))

-- Identifiers.
local identifier = token(l.IDENTIFIER, l.word)

-- Operators.
local operator = token(l.OPERATOR, word_match({
  'AND', 'COMMAND', 'DEFINED', 'DOC', 'EQUAL', 'EXISTS', 'GREATER', 'INTERNAL',
  'LESS', 'MATCHES', 'NAME', 'NAMES', 'NAME_WE', 'NOT', 'OR', 'PATH', 'PATHS',
  'PROGRAM', 'STREQUAL', 'STRGREATER', 'STRINGS', 'STRLESS'
}) + S('=(){}'))

M._rules = {
  {'whitespace', ws},
  {'keyword', keyword},
  {'command', command},
  {'constant', constant},
  {'variable', variable},
  {'operator', operator},
  {'identifier', identifier},
  {'string', string},
  {'comment', comment},
}

M._foldsymbols = {
  _patterns = {'[A-Z]+', '[%(%){}]', '#'},
  [l.KEYWORD] = {
    IF = 1, ENDIF = -1, FOREACH = 1, ENDFOREACH = -1, WHILE = 1, ENDWHILE = -1
  },
  [l.FUNCTION] = {MACRO = 1, ENDMACRO = -1},
  [l.OPERATOR] = {['('] = 1, [')'] = -1, ['{'] = 1, ['}'] = -1},
  [l.COMMENT] = {['#'] = l.fold_line_comments('#')}
}

return M
