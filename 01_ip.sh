#!/bin/bash

comprobarCorrecto() {
	local ip="$1"
	#if [[ "$ip" == *.*.*.* ]]; then
		local esNumero='^-?[0-9]+$'
		local bytes=$(echo "$ip" | cut -d '.' -f 1- | tr '.' ' ')
		# Comprobar si la ip son 4 bytes
		local numBytes=$(echo $bytes | wc -w)
		if [ $numBytes -ne 4 ]; then
			correcto=0
		fi
		# Comprobar si los 4 bytes son números y de rango correcto
		for byte in $bytes; do
			if ! [[ "$byte" =~ $esNumero ]] || [ "$byte" -lt 0 ] || [ "$byte" -gt 255 ]; then
				correcto=0
				break
			fi
		done
	#else
	#	correcto=0
	#fi
}

echo " * [ Step 1 ] Verificando permisos"

if [ "$(id -u)" -ne 0 ];then
	echo "   [ ERROR ] Necesitas permisos de root"
	echo "   [ USO ] sudo $0" && exit 1
fi
echo "Ok"

echo " * [ Step 2 ] Verificando pasado parámetro"

IP="$1"

if [ -z $IP ]; then
	echo "   [ ERROR ] No se ha pasado un parámetro"
	echo "   [ USO ] : sudo $0 dirección IP" && exit 1
fi
if ! [ $# -eq 1 ]; then
	echo "   [ ERROR ] No se ha pasado un parámetro"
	echo "   [ USO ] : sudo $0 dirección IP" && exit 1
fi
echo "Ok"

echo " * [ Step 3 ] Verificando parámetro es una dirección IP válida"

correcto=1
comprobarCorrecto $IP
if [ $correcto -eq 0 ]; then
	echo "   [ ERROR ] $IP no es una dirección IP válida" && exit 1
fi
echo "Ok"
#if [[ $IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
#	echo "   [ ERROR ] $IP no es una dirección IP válida" && exit 1
#fi

echo " * [ Step 4 ] Verificando que $IP es accesible"

ping -c 1 $IP >/dev/null 2>&1

if [ $? -ne 0 ]; then
	echo "   [ ERROR ] $IP no es accesible" && exit 1
fi
echo "Ok"
#ping $IP -c 1 || correcto=0

#if [ $correcto -eq 0 ]; then
#	echo "   [ ERROR ] $IP no es accesible" && exit 1
#fi


echo " * [ Step 5 ] Lista de servicios"

nmap $IP

exit 0

