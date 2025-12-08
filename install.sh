###################################
# Prerequisites

# Update the list of packages
sudo apt-get update #actualizar la lista de paquetes

# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common #Ejecutar como superusuario la instalación automática de tres herramientas esenciales: wget, apt-transport-https y software-properties-common.

# Get the version of Ubuntu
source /etc/os-release #Ejecutar el archivo de configuración del sistema operativo en el entorno de shell actual

# Download the Microsoft repository keys
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb #Descargar de forma silenciosa el archivo de configuración de Microsoft packages-microsoft-prod.deb para la versión específica de Ubuntu que se esté utilizando

# Register the Microsoft repository keys
sudo dpkg -i packages-microsoft-prod.deb #Ejecutar como superusuario la instalación del paquete de configuración de Microsoft -packages-microsoft-prod.deb- usando la herramienta dpkg

# Delete the Microsoft repository keys file
rm packages-microsoft-prod.deb #eliminar el archivo -packages-microsoft-prod.deb-

# Update the list of packages after we added packages.microsoft.com
sudo apt-get update #actualizar la lista de paquetes

###################################
# Install PowerShell
sudo apt-get install -y powershell #Ejecutar como superusuario la instalación automática del programa powershell

# Start PowerShell
pwsh #ejecutar powershell