Add-Type -AssemblyName System.Windows.Forms

# Créer une nouvelle fenêtre
$form = New-Object System.Windows.Forms.Form
$form.Text = "Informations des périphériques de stockage"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"

# Créer une zone de texte pour afficher les informations
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Multiline = $true
$textbox.ScrollBars = "Vertical"
$textbox.Location = New-Object System.Drawing.Point(10, 10)
$textbox.Size = New-Object System.Drawing.Size(570, 300)
$textbox.ReadOnly = $true
$form.Controls.Add($textbox)

# Créer le bouton de rafraîchissement
$buttonRefresh = New-Object System.Windows.Forms.Button
$buttonRefresh.Location = New-Object System.Drawing.Point(10, 320)
$buttonRefresh.Size = New-Object System.Drawing.Size(100, 30)
$buttonRefresh.Text = "Rafraîchir"
$buttonRefresh.Add_Click({
    # Effacer le contenu de la zone de texte
    $textbox.Clear()

    # Obtenir les informations des périphériques de stockage
    $disks = Get-PhysicalDisk | Sort-Object DeviceID

    # Afficher les informations des périphériques de stockage
    foreach ($disk in $disks) {
        $diskNumber = $disk.DeviceID
        $model = $disk.Model
        $size = "{0:N2} GB" -f ($disk.Size / 1GB)
        $interfaceType = $disk.InterfaceType
        $healthStatus = $disk.HealthStatus
        $textbox.AppendText("Périphérique : $diskNumber`r`n")
        $textbox.AppendText("Modèle : $model`r`n")
        $textbox.AppendText("Taille : $size`r`n")
        $textbox.AppendText("Type d'interface : $interfaceType`r`n")
        $textbox.AppendText("État de santé : $healthStatus`r`n`r`n")
    }
})
$form.Controls.Add($buttonRefresh)

# Ajouter le crédit
$labelCredit = New-Object System.Windows.Forms.Label
$labelCredit.Location = New-Object System.Drawing.Point(10, 360)
$labelCredit.Size = New-Object System.Drawing.Size(570, 20)
$labelCredit.Text = "Script réalisé par [Romain.V]"
$form.Controls.Add($labelCredit)

# Afficher la fenêtre
$form.ShowDialog()