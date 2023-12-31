with import <nixpkgs> {};

pkgs.mkShell {
  LOCALE_ARCHIVE_2_27 = "${glibcLocales}/lib/locale/locale-archive";
  buildInputs = [
    pkgs.texlive.combined.scheme-full
  ];
}
