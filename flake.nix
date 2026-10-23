
{
  description = "Local development for josepalos.github.io";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };

          common = with pkgs; [
            ruby
            bundler
            nodejs
            gcc
            gnumake
            pkg-config
          ];
        in {
          serve = pkgs.writeShellApplication {
            name = "serve";
            runtimeInputs = with pkgs; common ++ [];
            text = ''
              bundle check || bundle install
              exec bundle exec jekyll serve \
                --livereload \
                --host 127.0.0.1 \
                "$@"
            '';
          };
          default = self.packages.${system}.serve;
        });
    };
}

