# script3.ps1

function New-FolderCreation {  #define una función auxiliar para crear carpetas
    [CmdletBinding()]  #habilita funciones avanzadas de PowerShell (como -Verbose)
    param(  #inicia la definición de parámetros
        [Parameter(Mandatory = $true)] #indica que este parámetro es obligatorio
        [string]$foldername #el nombre de la carpeta a crear (tipo texto)
    )

    # Create absolute path for the folder relative to current location
    $logpath = Join-Path -Path (Get-Location).Path -ChildPath $foldername #crea la ruta completa combinando dónde estás + el nombre de carpeta
    if (-not (Test-Path -Path $logpath)) { #si la ruta NO existe (-not Test-Path)...
        New-Item -Path $logpath -ItemType Directory -Force | Out-Null #crea la carpeta nueva y oculta el mensaje de éxito
    }

    return $logpath #devuelve la ruta completa de la carpeta creada
}

function Write-Log { #define la función principal para gestionar logs
    [CmdletBinding()] #habilita el uso de ParameterSets (modos de uso)
    param(
        # Create parameter set
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')] #solo obligatorio si usamos el modo 'Create'
        [Alias('Names')] #permite usar -Names como sinónimo de -Name
        [object]$Name, #nombre del log (puede ser uno o varios)

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')] #obligatorio en modo 'Create'
        [string]$Ext,                                             #la extensión del archivo (ej: txt, log)

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')] #obligatorio en modo 'Create'
        [string]$folder, #carpeta donde se guardará

        [Parameter(ParameterSetName = 'Create', Position = 0)]  #switch para activar el modo 'Create'
        [switch]$Create, #es un interruptor (on/off)

        # Message parameter set 
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')] #obligatorio en modo 'Message'
        [string]$message, #el texto que queremos guardar

        [Parameter(Mandatory = $true, ParameterSetName = 'Message')] #obligatorio en modo 'Message'
        [string]$path, #la ruta del archivo donde escribir

        [Parameter(Mandatory = $false, ParameterSetName = 'Message')] #opcional en modo 'Message'
        [ValidateSet('Information','Warning','Error')] #solo permite elegir una de estas 3 palabras
        [string]$Severity = 'Information', #valor por defecto si no se especifica nada

        [Parameter(ParameterSetName = 'Message', Position = 0)]  #switch para activar el modo 'Message'
        [switch]$MSG #interruptor para el modo mensaje
    )

    switch ($PsCmdlet.ParameterSetName) { #revisa qué modo ('Create' o 'Message') eligió el usuario
        "Create" { #bloque de codigo para crear archivos
            $created = @() #crea una lista vacía para guardar resultados

            # Normalize $Name to an array
            $namesArray = @() #prepara una lista vacía
            if ($null -ne $Name) { #si $Name no está vacío...
                if ($Name -is [System.Array]) { $namesArray = $Name } #si ya es una lista, la usa tal cual
                else { $namesArray = @($Name) } #si es un solo texto, lo convierte en lista
            }

            # Date + time formatting (safe for filenames)
            $date1 = (Get-Date -Format "yyyy-MM-dd") #fecha actual (Año-Mes-Dia)
            $time  = (Get-Date -Format "HH-mm-ss") #hora actual (Hora-Min-Seg)

            # Ensure folder exists and get absolute folder path
            $folderPath = New-FolderCreation -foldername $folder #llama a la otra función para asegurar que la carpeta exista

            foreach ($n in $namesArray) { #recorre cada nombre en la lista
                # sanitize name to string
                $baseName = [string]$n #se asegura de que el nombre sea texto

                # Build filename
                $fileName = "${baseName}_${date1}_${time}.$Ext" #construye el nombre: Nombre_Fecha_Hora.Extension

                # Full path for file
                $fullPath = Join-Path -Path $folderPath -ChildPath $fileName #crea la ruta completa final

                # Create the file
                try { #intenta ejecutar este bloque (manejo de errores)
                    # New-Item crea el archivo. -Force sobrescribe si existe. -ErrorAction Stop detiene si falla.
                    New-Item -Path $fullPath -ItemType File -Force -ErrorAction Stop | Out-Null
                    
                    # (Comentario original: Opcionalmente escribir encabezado)
                    
                    $created += $fullPath #agrega la ruta del archivo creado a la lista de resultados
                }
                catch { #si falla el 'try', ejecuta esto:
                    Write-Warning "Failed to create file '$fullPath' - $_" #muestra advertencia amarilla con el error
                }
            }

            return $created #devuelve la lista de archivos creados
        }

        "Message" { #bloque de codigo para escribir LOGS
            # Ensure directory for message file exists
            $parent = Split-Path -Path $path -Parent #obtiene la carpeta padre del archivo
            if ($parent -and -not (Test-Path -Path $parent)) { #si la carpeta padre no existe...
                New-Item -Path $parent -ItemType Directory -Force | Out-Null #la crea
            }

            $date = Get-Date #obtiene fecha y hora actual exacta
            $concatmessage = "|$date| |$message| |$Severity|" #crea el formato del log: |Fecha| |Mensaje| |Gravedad|

            switch ($Severity) { #cambia el color de la consola según la gravedad
                "Information" { Write-Host $concatmessage -ForegroundColor Green } #verde para info
                "Warning"     { Write-Host $concatmessage -ForegroundColor Yellow } #amarillo para advertencia
                "Error"       { Write-Host $concatmessage -ForegroundColor Red } #rojo para error
            }

            # Append message to the specified path
            Add-Content -Path $path -Value $concatmessage -Force #escribe el texto al final del archivo

            return $path #devuelve la ruta del archivo editado
        }

        default { #si no cae en ningún caso anterior (raro)
            throw "Unknown parameter set: $($PsCmdlet.ParameterSetName)" #lanza un error crítico
        }
    }
}

# ---------- Example usage ----------
# Crea la carpeta "logs" y dentro crea un archivo vacío llamado "Name-Log_FECHA_HORA.log"
$logPaths = Write-Log -Name "Name-Log" -folder "logs" -Ext "log" -Create
$logPaths #muestra en pantalla la ruta del archivo creado