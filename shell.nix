{ sources ? import ./nix/sources.nix }:
with import sources.nixpkgs {
  overlays = [
    (import sources.myNixPythonPackages)
  ];
};

let
  my-python-packages = python-packages: with python-packages; [
    matplotlib
    h5py
    # other python packages you want
  ];
  python-with-my-packages = python3.withPackages my-python-packages;
in
mkShell {
  buildInputs = [
    python-with-my-packages
    jupyter
    julia-bin
    gcc
  ];

  shellHooks = ''
    export JULIA_DEPOT_PATH=/var/tmp/$PWD/julia
    mkdir -p $JULIA_DEPOT_PATH
    julia -e 'using Pkg; Pkg.add("Revise"); Pkg.activate("."); Pkg.precompile()'
    mkdir -p $JULIA_DEPOT_PATH/config/ && echo "using Revise" >> $JULIA_DEPOT_PATH/config/startup.jl
  '';
}
