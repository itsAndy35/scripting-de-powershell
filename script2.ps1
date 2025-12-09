Add-Type -AssemblyName System.Windows.Forms #carga la librería de .NET necesaria para crear ventanas y formularios
Add-Type -AssemblyName System.Drawing #carga la librería para manejar gráficos, tamaños y posiciones

# Create form
$form = New-Object System.Windows.Forms.Form # crea un nuevo objeto de ventana (formulario) vacío
$form.Text = "Input Form" # establece el título que aparece en la barra superior de la ventana
$form.Size = New-Object System.Drawing.Size(500,250) #define el tamaño de la ventana: 500px de ancho por 250px de alto
$form.StartPosition = "CenterScreen" #configura la ventana para que aparezca justo en el centro de la pantalla

############# Define labels
$textLabel1 = New-Object System.Windows.Forms.Label #crea la primera etiqueta de texto
$textLabel1.Text = "Input 1:" #define qué dice la etiqueta (Texto visible)
$textLabel1.Left = 20 #posición horizontal (distancia desde el borde izquierdo)
$textLabel1.Top = 20  #posición vertical (distancia desde el borde superior)
$textLabel1.Width = 120 #ancho reservado para este texto

$textLabel2 = New-Object System.Windows.Forms.Label #crea la segunda etiqueta
$textLabel2.Text = "Input 2:" #texto visible de la segunda etiqueta
$textLabel2.Left = 20 #misma posición horizontal (alineado con el de arriba)
$textLabel2.Top = 60 #posición vertical más baja (para que no se encimen)
$textLabel2.Width = 120 #ancho de la etiqueta

$textLabel3 = New-Object System.Windows.Forms.Label #crea la tercera etiqueta
$textLabel3.Text = "Input 3:" #texto visible de la tercera etiqueta
$textLabel3.Left = 20 #posición horizontal
$textLabel3.Top = 100 #Posición vertical
$textLabel3.Width = 120 #ancho de la etiqueta

############# Textbox 1
$textBox1 = New-Object System.Windows.Forms.TextBox #crea la primera caja donde el usuario puede escribir
$textBox1.Left = 150 #posición horizontal (a la derecha de la etiqueta)
$textBox1.Top = 20 #posición vertical (alineado con la etiqueta 1)
$textBox1.Width = 200 #ancho de la caja de texto

############# Textbox 2
$textBox2 = New-Object System.Windows.Forms.TextBox #crea la segunda caja de texto
$textBox2.Left = 150 #posición horizontal
$textBox2.Top = 60 #posición vertical (alineado con la etiqueta 2)
$textBox2.Width = 200 #ancho de la caja

############# Textbox 3
$textBox3 = New-Object System.Windows.Forms.TextBox #crea la tercera caja de texto
$textBox3.Left = 150 #posición horizontal
$textBox3.Top = 100 #posición vertical (alineado con la etiqueta 3)
$textBox3.Width = 200 #ancho de la caja

############# Default values
$defaultValue = "" #crea una variable con texto vacío
$textBox1.Text = $defaultValue #asigna texto vacío a la caja 1
$textBox2.Text = $defaultValue #asigna texto vacío a la caja 2
$textBox3.Text = $defaultValue #asigna texto vacío a la caja 3

############# OK Button
$button = New-Object System.Windows.Forms.Button #crea un objeto de tipo botón
$button.Left = 360 #posición horizontal del botón
$button.Top = 140 #posición vertical del botón
$button.Width = 100 #ancho del botón
$button.Text = "OK" #texto que aparece dentro del botón

############# Button click event
$button.Add_Click({ #abre el bloque de código que se ejecuta al hacer clic
    $form.Tag = @{ #usa la propiedad .Tag del formulario como "mochila" para guardar datos
        Box1 = $textBox1.Text #guarda lo que el usuario escribió en la caja 1
        Box2 = $textBox2.Text #guarda lo que el usuario escribió en la caja 2
        Box3 = $textBox3.Text #guarda lo que el usuario escribió en la caja 3
    }
    $form.Close() #cierra la ventana visual
})

############# Add controls
$form.Controls.Add($button) #agrega el botón al formulario
$form.Controls.Add($textLabel1) #agrega la etiqueta 1
$form.Controls.Add($textLabel2) #agrega la etiqueta 2
$form.Controls.Add($textLabel3) #agrega la etiqueta 3
$form.Controls.Add($textBox1) #agrega la caja de texto 1
$form.Controls.Add($textBox2) #agrega la caja de texto 2
$form.Controls.Add($textBox3) #agrega la caja de texto 3

############# Show dialog
$form.ShowDialog() | Out-Null #muestra la ventana y pausa el script hasta que se cierre. Out-Null oculta el resultado técnico.

############# Return values
return $form.Tag.Box1, $form.Tag.Box2, $form.Tag.Box3 #devuelve al script los 3 valores que guardamos en la "mochila" (Tag)