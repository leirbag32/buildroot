GFXSTREAM_VERSION = v0.1.2-gfxstream-release
GFXSTREAM_SITE = https://github.com
GFXSTREAM_SITE_METHOD = git
GFXSTREAM_LICENSE = Apache-2.0
GFXSTREAM_INSTALL_STAGING = YES

GFXSTREAM_DEPENDENCIES = libdrm mesa3d vulkan-headers vulkan-loader libaemu

# Provide minimal GL/glx.h stub so GLDispatch.cpp compiles without X11/GLX packages
define GFXSTREAM_INSTALL_GLX_STUB
	mkdir -p $(STAGING_DIR)/usr/include/GL
	printf '%s\n' \
		'#ifndef __glx_h__' \
		'#define __glx_h__' \
		'typedef unsigned char GLubyte;' \
		'typedef void (*__GLXextFuncPtr)(void);' \
		'typedef struct __GLXcontextRec *GLXContext;' \
		'typedef unsigned long GLXDrawable;' \
		'extern __GLXextFuncPtr glXGetProcAddress(const GLubyte *procName);' \
		'extern __GLXextFuncPtr glXGetProcAddressARB(const GLubyte *procName);' \
		'#endif' \
		> $(STAGING_DIR)/usr/include/GL/glx.h
endef

GFXSTREAM_PRE_CONFIGURE_HOOKS += GFXSTREAM_INSTALL_GLX_STUB

GFXSTREAM_CXXFLAGS = $(TARGET_CXXFLAGS) -include cstdint

GFXSTREAM_CONF_OPTS = \
	-Ddecoders=gles,vulkan,composer,magma \
	-Dcpp_args="$(GFXSTREAM_CXXFLAGS)"

$(eval $(meson-package))

