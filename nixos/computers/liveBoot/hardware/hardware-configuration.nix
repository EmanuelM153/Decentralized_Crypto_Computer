{
  system,
  ...
}:

{
  hardware = {
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
  };

  nixpkgs.hostPlatform = system;
}
