{ system ? builtins.currentSystem
, sources ? import ./nix/sources.nix
}: let
	pkgs = import sources.nixpkgs {
		inherit system;
		config.packageOverrides = pkgs: {
			nur = import sources.NUR { inherit pkgs; };
			unstable = import sources.unstable { inherit pkgs; };
		};
	};
	inherit (pkgs) lib mkShell;
in mkShell {
	packages = [
		pkgs.editorconfig-checker
		pkgs.unstable.git-ps-rs
	] ++ lib.optionals (builtins.getEnv "CI" != "") [ # CI-only
	] ++ lib.optionals (builtins.getEnv "CI" == "") [ # local-only
	];
}
