{
  autoPatchelfHook,
  desktop-file-utils,
  dpkg,
  fetchurl,
  iw,
  lib,
  libayatana-appindicator,
  makeWrapper,
  nettools,
  qt6,
  stdenv,
  webkitgtk_4_1,
  wirelesstools,
  xdg-utils,
}:

stdenv.mkDerivation rec {
  version = "1.2.5";
  pname = "wifiman";

  src = fetchurl {
    url = "https://desktop.ea.wifiman.com/wifiman-desktop-${version}-amd64.deb";
    hash = "sha256-Caobtr1wMEfrNH/6Ndxw1cbPArCVhrc59VtRus8+FDo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    desktop-file-utils
    iw
    libayatana-appindicator
    nettools
    qt6.qttools
    qt6.wrapQtAppsHook
    webkitgtk_4_1
    wirelesstools
    xdg-utils
  ];

  installPhase = ''
    mv usr $out
    # Wrap the service binary
    makeWrapper $out/lib/wifiman-desktop/wifiman-desktopd $out/bin/wifiman-desktopd \
      --prefix PATH : ${
      lib.makeBinPath [
        iw
        nettools
        wirelesstools
      ]
    }
    # Wrap the desktop binary
    wrapProgram $out/bin/wifiman-desktop \
      --prefix PATH : ${
        lib.makeBinPath [
          desktop-file-utils
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libayatana-appindicator
        ]
      }
  '';

  meta = with lib; {
    description = "Desktop App for UniFi Device Discovery and Teleport VPN";
    homepage = "https://wifiman.com";
    license = licenses.unfree;
    mainProgram = "wifiman-desktop";
    maintainers = with maintainers; [ neverbehave ruffsl ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
