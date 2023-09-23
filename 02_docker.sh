#!/bin/bash

c=0
echo "  | Nombre contenedor | IP Red |"

# ******************************************************** METODO 1 *********************************************************************************

# A partir de la primera línea (al no tener la columna 11 da error), nos quedamos con el nombre de los contenedores que están en ejecución (docker ps)
estadoUp=$(docker ps | awk 'NR>1 {print $11}')

while read -r contenedor; do
		((c++))
		# Lo que nos interesa es la primera columna de la última línea
		ip=$(docker exec $contenedor cat /etc/hosts | tail -n 1 | awk '{print $1}')
		echo "$c | $contenedor | $ip |"
done <<< "$estadoUp"

# ******************************************************** METODO 2 *********************************************************************************

# De TODOS los contenedores (docker ps -a), buscamos líneas que contengan "Up" para quedarnos con el nombre del contenedor (columna 11), 
# pero nos quedamos también con la 7 para eliminar posibles falsos positivos
#estadoUp=$(docker ps -a | awk '/Up/ {print $7, $11}')

#while read -r funcionando contenedor; do
#	# Validamos que la la columna 7 es "Up"
#	if [[ "$funcionando" == "Up" ]]; then
#		((c++))
#		# Lo que nos interesa es la primera columna de la última línea
#		ip=$(docker exec $contenedor cat /etc/hosts | tail -n 1 | awk '{print $1}')
#		echo "$c | $contenedor | $ip |"
#	fi
#done <<< "$estadoUp"

exit 0




