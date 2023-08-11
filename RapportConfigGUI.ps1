Add-Type -AssemblyName System.Windows.Forms

# Créer une nouvelle fenêtre
$form = New-Object System.Windows.Forms.Form
$form.Text = "Rapport de configuration"
$form.Size = New-Object System.Drawing.Size(500, 400)
$form.StartPosition = "CenterScreen"

# Créer une zone de texte pour afficher le rapport
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Multiline = $true
$textbox.ScrollBars = "Vertical"
$textbox.Location = New-Object System.Drawing.Point(10, 10)
$textbox.Size = New-Object System.Drawing.Size(470, 300)
$textbox.ReadOnly = $true
$form.Controls.Add($textbox)

# Créer le bouton de génération du rapport
$buttonGenerer = New-Object System.Windows.Forms.Button
$buttonGenerer.Location = New-Object System.Drawing.Point(10, 320)
$buttonGenerer.Size = New-Object System.Drawing.Size(100, 30)
$buttonGenerer.Text = "Générer rapport"
$buttonGenerer.Add_Click({
    # Obtenir les informations système
    $computerName = $env:COMPUTERNAME
    $operatingSystem = Get-CimInstance Win32_OperatingSystem
    $processor = Get-CimInstance Win32_Processor
    $memory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    $diskDrives = Get-CimInstance Win32_DiskDrive
    $networkAdapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null }

    # Obtenir les informations sur les logiciels installés
    $installedSoftware = Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor

    # Créer le rapport
    $report = @"
INFORMATIONS SYSTÈME
--------------------
Nom de l'ordinateur: $computerName
Système d'exploitation: $($operatingSystem.Caption) $($operatingSystem.Version)
Processeur: $($processor.Name)
Mémoire installée: $($memory.Sum / 1GB) Go
"@

    if ($diskDrives) {
        $report += @"
DRIVES DE STOCKAGE
------------------
"@
        foreach ($drive in $diskDrives) {
            $report += "Modèle: $($drive.Model)`n"
            $report += "Taille: $($drive.Size / 1GB) Go`n`n"
        }
    }

    if ($networkAdapters) {
        $report += @"
ADAPTATEURS RÉSEAU
------------------
"@
        foreach ($adapter in $networkAdapters) {
            $report += "Nom: $($adapter.Description)`n"
            $report += "Adresse IP: $($adapter.IPAddress)`n`n"
        }
    }

    $report += @"
LOGICIELS INSTALLÉS
-------------------
"@
    if ($installedSoftware) {
        foreach ($software in $installedSoftware) {
            $report += "Nom: $($software.Name)`n"
            $report += "Version: $($software.Version)`n"
            $report += "Fournisseur: $($software.Vendor)`n`n"
        }
    }
    else {
        $report += "Aucun logiciel installé.`n"
    }

    # Afficher le rapport dans la zone de texte
    $textbox.Text = $report
})

$form.Controls.Add($buttonGenerer)

# Créer le bouton d'exportation du rapport
$buttonExporter = New-Object System.Windows.Forms.Button
$buttonExporter.Location = New-Object System.Drawing.Point(120, 320)
$buttonExporter.Size = New-Object System.Drawing.Size(100, 30)
$buttonExporter.Text = "Exporter rapport"
$buttonExporter.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "Fichier texte (*.txt)|*.txt"
    $saveFileDialog.Title = "Exporter rapport"
    $saveFileDialog.ShowDialog()

    if ($saveFileDialog.FileName -ne "") {
        $textbox.Text | Out-File -FilePath $saveFileDialog.FileName
        [System.Windows.Forms.MessageBox]::Show("Le rapport de configuration a été exporté avec succès.", "Exportation réussie", "OK", [System.Windows.Forms.MessageBoxIcon]::Information)
    }
})

$form.Controls.Add($buttonExporter)

# Créer le label de crédit
$labelCredit = New-Object System.Windows.Forms.Label
$labelCredit.Location = New-Object System.Drawing.Point(10, 360)
$labelCredit.Size = New-Object System.Drawing.Size(300, 20)
$labelCredit.Text = "Script réalisé par [Romain.V]"
$form.Controls.Add($labelCredit)

# Afficher la fenêtre
$form.ShowDialog()


