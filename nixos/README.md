# Configuración de la instalación de NixOS
En este directorio se encuentra la configuración, escrita en Nix, para instalar la distribución de Linux, NixOS, en los nodos

## Creación de la imagen iso
Después de instalar nix, se ejecuta desde este directorio el siguiente comando:
`nix build "./computers/liveBoot#nixosConfigurations.liveBoot.config.system.build.isoImage"`

Y la imagen se crea en el directorio result/iso
