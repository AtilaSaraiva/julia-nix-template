{ sources ? import ./nix/sources.nix }:
with import sources.nixpkgs {
  overlays = [
    (import sources.myNixPythonPackages)
  ];
};

(let
  my-python-packages = python-packages: with python-packages; [
    matplotlib
    h5py
    # other python packages you want
  ];
  python-with-my-packages = python3.withPackages my-python-packages;
in
  buildFHSUserEnv {
  name = "simple-julia-env";
  targetPkgs = pkgs: (with pkgs;
  [
    julia-bin
    python-with-my-packages
  ]);
  runScript = ''
    bash -c "source ./env && bash"
  '';
}).env
