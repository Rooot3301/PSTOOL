Add-Type -AssemblyName System.Windows.Forms

# Créer une fenêtre
$form = New-Object System.Windows.Forms.Form
$form.Text = "Outil de compression/décompression par ROOT3301"
$form.Width = 400
$form.Height = 300

# Créer des boutons radio pour les options
$radioZip = New-Object System.Windows.Forms.RadioButton
$radioZip.Text = "Zip"
$radioZip.Location = New-Object System.Drawing.Point(20, 30)
$radioZip.Checked = $true

$radioUnzip = New-Object System.Windows.Forms.RadioButton
$radioUnzip.Text = "Dézip"
$radioUnzip.Location = New-Object System.Drawing.Point(20, 60)

# Créer une étiquette pour le chemin du fichier
$labelFile = New-Object System.Windows.Forms.Label
$labelFile.Text = "Chemin du fichier :"
$labelFile.Location = New-Object System.Drawing.Point(20, 100)

# Créer une zone de texte pour entrer le chemin du fichier
$textBoxFile = New-Object System.Windows.Forms.TextBox
$textBoxFile.Location = New-Object System.Drawing.Point(180, 100)
$textBoxFile.Width = 150

# Créer une étiquette pour le dossier de destination
$labelDestination = New-Object System.Windows.Forms.Label
$labelDestination.Text = "Dossier de destination :"
$labelDestination.Location = New-Object System.Drawing.Point(20, 140)

# Créer une zone de texte pour entrer le dossier de destination
$textBoxDestination = New-Object System.Windows.Forms.TextBox
$textBoxDestination.Location = New-Object System.Drawing.Point(180, 140)
$textBoxDestination.Width = 150

# Créer un bouton d'exécution
$buttonExecute = New-Object System.Windows.Forms.Button
$buttonExecute.Text = "Exécuter"
$buttonExecute.Location = New-Object System.Drawing.Point(150, 180)
$buttonExecute.add_Click({
    $action = "Zip"
    if ($radioUnzip.Checked) {
        $action = "Dézip"
    }

    $filePath = $textBoxFile.Text
    $destinationFolder = $textBoxDestination.Text
    
    if (Test-Path -Path $filePath) {
        if ($action -eq "Zip") {
            $zipFilePath = Join-Path -Path $destinationFolder -ChildPath "$([System.IO.Path]::GetFileNameWithoutExtension($filePath)).zip"
            Compress-Archive -Path $filePath -DestinationPath $zipFilePath -Force
            [System.Windows.Forms.MessageBox]::Show("Fichier zippé avec succès.")
        } else {
            if (-not (Test-Path -Path $destinationFolder -PathType Container)) {
                New-Item -Path $destinationFolder -ItemType Directory
            }
            Expand-Archive -Path $filePath -DestinationPath $destinationFolder -Force
            [System.Windows.Forms.MessageBox]::Show("Fichier dézippé avec succès.")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Le fichier spécifié n'existe pas.")
    }
})

# Ajouter les contrôles à la fenêtre
$form.Controls.Add($radioZip)
$form.Controls.Add($radioUnzip)
$form.Controls.Add($labelFile)
$form.Controls.Add($textBoxFile)
$form.Controls.Add($labelDestination)
$form.Controls.Add($textBoxDestination)
$form.Controls.Add($buttonExecute)

# Afficher la fenêtre
$form.ShowDialog()





