Add-Type -AssemblyName System.Windows.Forms

# Créer une nouvelle fenêtre
$form = New-Object System.Windows.Forms.Form
$form.Text = "Copie de fichiers - Par Romain.V"
$form.Size = New-Object System.Drawing.Size(400, 230)
$form.StartPosition = "CenterScreen"

# Créer un contrôle de sélection du répertoire source
$labelSource = New-Object System.Windows.Forms.Label
$labelSource.Location = New-Object System.Drawing.Point(10, 20)
$labelSource.Size = New-Object System.Drawing.Size(120, 20)
$labelSource.Text = "Répertoire source:"
$form.Controls.Add($labelSource)

$textboxSource = New-Object System.Windows.Forms.TextBox
$textboxSource.Location = New-Object System.Drawing.Point(130, 20)
$textboxSource.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textboxSource)

$buttonSource = New-Object System.Windows.Forms.Button
$buttonSource.Location = New-Object System.Drawing.Point(340, 20)
$buttonSource.Size = New-Object System.Drawing.Size(30, 20)
$buttonSource.Text = "..."
$buttonSource.Add_Click({
    $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $result = $folderBrowserDialog.ShowDialog()
    if ($result -eq "OK") {
        $textboxSource.Text = $folderBrowserDialog.SelectedPath
    }
})
$form.Controls.Add($buttonSource)

# Créer un contrôle de sélection du répertoire cible
$labelCible = New-Object System.Windows.Forms.Label
$labelCible.Location = New-Object System.Drawing.Point(10, 50)
$labelCible.Size = New-Object System.Drawing.Size(120, 20)
$labelCible.Text = "Répertoire cible:"
$form.Controls.Add($labelCible)

$textboxCible = New-Object System.Windows.Forms.TextBox
$textboxCible.Location = New-Object System.Drawing.Point(130, 50)
$textboxCible.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textboxCible)

$buttonCible = New-Object System.Windows.Forms.Button
$buttonCible.Location = New-Object System.Drawing.Point(340, 50)
$buttonCible.Size = New-Object System.Drawing.Size(30, 20)
$buttonCible.Text = "..."
$buttonCible.Add_Click({
    $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $result = $folderBrowserDialog.ShowDialog()
    if ($result -eq "OK") {
        $textboxCible.Text = $folderBrowserDialog.SelectedPath
    }
})
$form.Controls.Add($buttonCible)

# Créer le bouton de copie
$buttonCopier = New-Object System.Windows.Forms.Button
$buttonCopier.Location = New-Object System.Drawing.Point(10, 90)
$buttonCopier.Size = New-Object System.Drawing.Size(100, 30)
$buttonCopier.Text = "Copier"
$buttonCopier.Add_Click({
    $repertoireSource = $textboxSource.Text
    $repertoireCible = $textboxCible.Text

    # Obtenir la liste des fichiers dans le répertoire source
    $files = Get-ChildItem -Path $repertoireSource -File

    # Parcourir chaque fichier et le copier dans le répertoire cible
    foreach ($file in $files) {
        $cheminCible = Join-Path -Path $repertoireCible -ChildPath $file.Name
        Copy-Item -Path $file.FullName -Destination $cheminCible
    }

    # Afficher un message une fois la copie terminée
    [System.Windows.Forms.MessageBox]::Show("La copie des fichiers est terminée.", "Terminé")
})
$form.Controls.Add($buttonCopier)

# Ajouter le crédit
$labelCredit = New-Object System.Windows.Forms.Label
$labelCredit.Location = New-Object System.Drawing.Point(10, 140)
$labelCredit.Size = New-Object System.Drawing.Size(380, 30)
$labelCredit.Text = "Script réalisé par Romain.V"
$form.Controls.Add($labelCredit)

# Afficher la fenêtre
$form.ShowDialog()
