{ config, lib, inputs, pkgs, ... }:
let
  cfg = config.suites.music;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};

  pywal-spicetify = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "pywal-spicetify";
    version = "0.1.1";

    src = pkgs.fetchFromGitHub {
      owner = "jhideki";
      repo = "pywal-spicetify";
      tag = finalAttrs.version;
      hash = "sha256-iyy1icLIvHo3MfkqGeQZ9pGnjxduqOK/EzJILTQ1I/4=";
    };

    cargoTestFlags = [ "--" "--skip" "wal::removes_both_files_in_any_combination" ];

    cargoHash = "sha256-vzfaIabU9Bj8Ow6Q2q7lCKJpV1Gt4C7uaYENrrhIMwU=";

    meta = {
      description = "A cli tool to apply pywal colors to spicetify";
      homepage = "https://github.com/jhideki/pywal-spicetify";
      license = lib.licenses.unlicense;
      maintainers = [ {
        email = "bryce@blazedeveloper.com";
        github = "blaze-developer";
        githubId = 73793525;
        name = "BlazeDev";
      } ];
    };
  });
in
{
  imports = [ inputs.spicetify-nix.nixosModules.spicetify ];

  options.suites.music.enable = lib.mkEnableOption "music apps";

  config = lib.mkIf cfg.enable {
    programs.spicetify = {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
        spicyLyrics
      ];

      theme = spicePkgs.themes.text;
    };

    environment.systemPackages = [ pywal-spicetify ];
  };
}