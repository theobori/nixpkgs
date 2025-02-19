{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  expat,
  fontconfig,
  freetype,
  libGL,
  xorg,
  AppKit,
}:

rustPlatform.buildRustPackage rec {
  pname = "epick";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "vv9k";
    repo = pname;
    rev = version;
    sha256 = "sha256-k0WQu1n1sAHVor58jr060vD5/2rDrt1k5zzJlrK9WrU=";
  };

  cargoHash = "sha256-OQZPOiMTpoWabxHa3TJG8L3zq8WxMeFttw8xggSXsMA=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      expat
      fontconfig
      freetype
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AppKit
    ];

  postInstall = ''
    install -Dm444 assets/epick.desktop -t $out/share/applications
    install -Dm444 assets/icon.svg $out/share/icons/hicolor/scalable/apps/epick.svg
    install -Dm444 assets/icon.png $out/share/icons/hicolor/48x48/apps/epick.png
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/epick --add-rpath ${lib.makeLibraryPath [ libGL ]}
  '';

  meta = with lib; {
    description = "Simple color picker that lets the user create harmonic palettes with ease";
    homepage = "https://github.com/vv9k/epick";
    changelog = "https://github.com/vv9k/epick/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "epick";
  };
}
