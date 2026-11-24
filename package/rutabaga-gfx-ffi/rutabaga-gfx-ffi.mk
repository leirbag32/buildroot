################################################################################
#
# rutabaga-gfx-ffi
#
################################################################################

RUTABAGA_GFX_FFI_VERSION = refs/tags/v0.1.85
RUTABAGA_GFX_FFI_SITE = https://github.com
RUTABAGA_GFX_FFI_SITE_METHOD = git
RUTABAGA_GFX_FFI_LICENSE = BSD-3-Clause
RUTABAGA_GFX_FFI_LICENSE_FILES = LICENSE
RUTABAGA_GFX_FFI_INSTALL_STAGING = YES

RUTABAGA_GFX_FFI_DEPENDENCIES = host-rustc host-pkgconf gfxstream libdrm

RUTABAGA_GFX_FFI_CARGO_ENV = \
	PATH="$(BR_PATH)" \
	RUSTC="$(HOST_DIR)/bin/rustc" \
	CARGO_HOME="$(@D)/.cargo-home" \
	RUSTFLAGS="-Clinker=$(TARGET_CC)" \
	PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)" \
	PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig" \
	PKG_CONFIG_ALLOW_CROSS=1

define RUTABAGA_GFX_FFI_CONFIGURE_CMDS
	cd $(@D)/ffi && \
	$(HOST_DIR)/bin/cargo generate-lockfile && \
	mkdir -p .cargo && \
	$(HOST_DIR)/bin/cargo vendor vendor > .cargo/config.toml
endef

define RUTABAGA_GFX_FFI_BUILD_CMDS
	cd $(@D)/ffi && \
	$(RUTABAGA_GFX_FFI_CARGO_ENV) $(HOST_DIR)/bin/cargo build \
		--release \
		--offline \
		--target=$(RUSTC_TARGET_NAME) \
		--features=gfxstream
endef

define RUTABAGA_GFX_FFI_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/librutabaga_gfx_ffi.so \
		$(STAGING_DIR)/usr/lib/librutabaga_gfx_ffi.so.0.1.85
	ln -sf librutabaga_gfx_ffi.so.0.1.85 $(STAGING_DIR)/usr/lib/librutabaga_gfx_ffi.so.0
	ln -sf librutabaga_gfx_ffi.so.0 $(STAGING_DIR)/usr/lib/librutabaga_gfx_ffi.so
	$(INSTALL) -D -m 0644 $(@D)/ffi/src/include/rutabaga_gfx_ffi.h \
		$(STAGING_DIR)/usr/include/rutabaga_gfx/rutabaga_gfx_ffi.h
	mkdir -p $(STAGING_DIR)/usr/lib/pkgconfig
	printf '%s\n' \
		'prefix=/usr' \
		'exec_prefix=$${prefix}' \
		'libdir=$${exec_prefix}/lib' \
		'includedir=$${prefix}/include' \
		'' \
		'Name: rutabaga_gfx_ffi' \
		'Description: C FFI bindings to Rutabaga VGI' \
		'Version: 0.1.85' \
		'Libs: -L$${libdir} -lrutabaga_gfx_ffi' \
		'Cflags: -I$${includedir}' \
		> $(STAGING_DIR)/usr/lib/pkgconfig/rutabaga_gfx_ffi.pc
endef

define RUTABAGA_GFX_FFI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/librutabaga_gfx_ffi.so \
		$(TARGET_DIR)/usr/lib/librutabaga_gfx_ffi.so.0.1.85
	ln -sf librutabaga_gfx_ffi.so.0.1.85 $(TARGET_DIR)/usr/lib/librutabaga_gfx_ffi.so.0
	ln -sf librutabaga_gfx_ffi.so.0 $(TARGET_DIR)/usr/lib/librutabaga_gfx_ffi.so
endef

$(eval $(generic-package))

