{ 
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libtelio";
  version = "5.1.9";

  src = fetchFromGitHub {
    owner = "NordSecurity";
    repo = "libtelio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2/3JN+o+7KpOChsOkYxsD8FXsQFtkCQut11vgIaYs+o=";
  };

  cargoPatches = [
    ./Cargo.lock.patch
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-KkDWO4H3TLmVuVGEisN5xWScvTNlU6odizNKxcwwLw8=";

  env = {
    BYPASS_LLT_SECRETS = "1";
  };

  doCheck = false;

  meta = {
    description = "A library providing networking utilities for NordVPN VPN and meshnet functionality";
    homepage = "https://github.com/NordSecurity/libtelio";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sanferdsouza ];
    platforms = lib.platforms.linux;
  };
})
