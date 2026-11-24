################################################################################
#
# libaemu
#
################################################################################

# Replace 'main' with a specific commit SHA from ://googlesource.com for reproducible builds
LIBAEMU_VERSION = v0.1.2-aemu-release
LIBAEMU_SITE = https://android.googlesource.com/platform/hardware/google/aemu
LIBAEMU_SITE_METHOD = git
LIBAEMU_LICENSE = Apache-2.0
LIBAEMU_LICENSE_FILES = LICENSE
LIBAEMU_INSTALL_STAGING = YES

LIBAEMU_DEPENDENCIES = lz4

LIBAEMU_CONF_OPTS = \
	-DAEMU_COMMON_GEN_PKGCONFIG=ON \
	-DAEMU_COMMON_BUILD_CONFIG=gfxstream \
	-DENABLE_VKCEREAL_TESTS=OFF

$(eval $(cmake-package))

