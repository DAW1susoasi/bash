#!/bin/bash

if [ "$(id -u)" -ne 0 ];then
	echo "   [ ERROR ] Necesitas permisos de root"
	echo "   [ USO ] sudo $0" && exit 1
fi

# Montamos el archivo ISO para acceder a su contenido:
echo "Montando Imagen"
mount -o loop /media/sf_xubuntu_22.04/xubuntu-22.04.1-desktop-amd64.iso /mnt

# Copiamos (por ejemplo en nuestro /home) el sistema de archivos squashfs (normalmente se encuentra en la ruta /casper/filesystem.squashfs) para trabajar con él
echo "Copiando filesystem.squashfs a nuestro home"
cp /mnt/casper/filesystem.squashfs ~/

# Desmontamos el archivo ISO
umount /mnt

# Descomprimimos con unsquashfs (si no está instalada la herramienta squashfs la podemos instalar con sudo apt install squashfs-tools)
# el sistema de archivos squashfs para poder acceder a su contenido
echo "Descomprimiendo filesystem.squashfs"
unsquashfs ~/filesystem.squashfs
rm ~/filesystem.squashfs
# Tras la descompresión se creará un directorio llamado squashfs-root que contiene el sistema de archivos descomprimido
# Montamos los directorios especiales /dev, /sys, /proc, etc. con --bind (bind lo que hace es que cuando yo vaya a /dev realmente estaré yendo a ~/squashfs-root/dev)
mount --bind /dev ~/squashfs-root/dev
mount --bind /sys ~/squashfs-root/sys
mount --bind /proc ~/squashfs-root/proc

# Utilizamos el comando chroot para cambiar el directorio raíz del sistema al directorio donde descomprimimos el sistema de archivos squashfs (nuestro /home)
echo "Cambiando directorio raiz del sistema"
chroot ~/squashfs-root

exit 0