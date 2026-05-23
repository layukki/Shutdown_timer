Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$script:form = New-Object System.Windows.Forms.Form
$script:form.Text = "Таймер выключения ПК"
$script:form.Size = New-Object System.Drawing.Size(400, 300)
$script:form.StartPosition = "CenterScreen"
$script:form.BackColor = [System.Drawing.Color]::FromArgb(18, 18, 28)
$script:form.FormBorderStyle = "FixedSingle"
$script:form.MaximizeBox = $false

$script:title = New-Object System.Windows.Forms.Label
$script:title.Text = "SHUTDOWN TIMER"
$script:title.Font = New-Object System.Drawing.Font("Consolas", 14, [System.Drawing.FontStyle]::Bold)
$script:title.ForeColor = [System.Drawing.Color]::FromArgb(0, 220, 180)
$script:title.Size = New-Object System.Drawing.Size(360, 30)
$script:title.Location = New-Object System.Drawing.Point(20, 18)
$script:form.Controls.Add($script:title)

$script:lbl = New-Object System.Windows.Forms.Label
$script:lbl.Text = "Через сколько часов выключить ПК?"
$script:lbl.Font = New-Object System.Drawing.Font("Consolas", 10)
$script:lbl.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 220)
$script:lbl.Size = New-Object System.Drawing.Size(360, 22)
$script:lbl.Location = New-Object System.Drawing.Point(20, 60)
$script:form.Controls.Add($script:lbl)

$script:input = New-Object System.Windows.Forms.TextBox
$script:input.Font = New-Object System.Drawing.Font("Consolas", 14, [System.Drawing.FontStyle]::Bold)
$script:input.ForeColor = [System.Drawing.Color]::FromArgb(0, 220, 180)
$script:input.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 45)
$script:input.BorderStyle = "FixedSingle"
$script:input.Size = New-Object System.Drawing.Size(210, 36)
$script:input.Location = New-Object System.Drawing.Point(20, 90)
$script:input.TextAlign = "Center"
$script:form.Controls.Add($script:input)

$script:secLabel = New-Object System.Windows.Forms.Label
$script:secLabel.Text = ""
$script:secLabel.Font = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
$script:secLabel.ForeColor = [System.Drawing.Color]::FromArgb(140, 140, 170)
$script:secLabel.Size = New-Object System.Drawing.Size(140, 36)
$script:secLabel.Location = New-Object System.Drawing.Point(240, 90)
$script:secLabel.TextAlign = "MiddleLeft"
$script:form.Controls.Add($script:secLabel)

$script:status = New-Object System.Windows.Forms.Label
$script:status.Text = ""
$script:status.Font = New-Object System.Drawing.Font("Consolas", 9)
$script:status.ForeColor = [System.Drawing.Color]::FromArgb(255, 120, 80)
$script:status.Size = New-Object System.Drawing.Size(360, 20)
$script:status.Location = New-Object System.Drawing.Point(20, 134)
$script:form.Controls.Add($script:status)

$script:btnSet = New-Object System.Windows.Forms.Button
$script:btnSet.Text = "ЗАПУСТИТЬ ТАЙМЕР"
$script:btnSet.Font = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
$script:btnSet.ForeColor = [System.Drawing.Color]::FromArgb(18, 18, 28)
$script:btnSet.BackColor = [System.Drawing.Color]::FromArgb(0, 220, 180)
$script:btnSet.FlatStyle = "Flat"
$script:btnSet.FlatAppearance.BorderSize = 0
$script:btnSet.Size = New-Object System.Drawing.Size(360, 38)
$script:btnSet.Location = New-Object System.Drawing.Point(20, 162)
$script:form.Controls.Add($script:btnSet)

$script:btnCancel = New-Object System.Windows.Forms.Button
$script:btnCancel.Text = "ОТМЕНИТЬ ТАЙМЕР"
$script:btnCancel.Font = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
$script:btnCancel.ForeColor = [System.Drawing.Color]::FromArgb(255, 120, 80)
$script:btnCancel.BackColor = [System.Drawing.Color]::FromArgb(40, 20, 20)
$script:btnCancel.FlatStyle = "Flat"
$script:btnCancel.FlatAppearance.BorderSize = 1
$script:btnCancel.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(255, 120, 80)
$script:btnCancel.Size = New-Object System.Drawing.Size(360, 34)
$script:btnCancel.Location = New-Object System.Drawing.Point(20, 208)
$script:form.Controls.Add($script:btnCancel)

$script:input.Add_TextChanged({
    $clean = $script:input.Text.Trim().Replace(",", ".")
    $result = 0.0
    $ok = [double]::TryParse($clean, [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$result)
    if ($ok -and $result -gt 0 -and $result -le 24) {
        $secs = [int]($result * 3600)
        $script:secLabel.Text = "= $secs сек"
    } else {
        $script:secLabel.Text = ""
    }
})

$script:btnSet.Add_Click({
    $clean = $script:input.Text.Trim().Replace(",", ".")
    $result = 0.0
    $ok = [double]::TryParse($clean, [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$result)
    if (-not $ok -or $result -le 0 -or $result -gt 24) {
        $script:status.ForeColor = [System.Drawing.Color]::FromArgb(255, 120, 80)
        $script:status.Text = "Ошибка: введите число от 0,1 до 24"
        return
    }
    $seconds = [int]($result * 3600)
    $timeStr = (Get-Date).AddSeconds($seconds).ToString("HH:mm:ss")
    shutdown -s -t $seconds
    $script:status.ForeColor = [System.Drawing.Color]::FromArgb(0, 220, 180)
    $script:status.Text = "Выключение в $timeStr ($seconds сек)"
    $script:input.Text = ""
    $script:secLabel.Text = ""
})

$script:btnCancel.Add_Click({
    shutdown -a
    $script:status.ForeColor = [System.Drawing.Color]::FromArgb(255, 200, 80)
    $script:status.Text = "Таймер отменён."
})

$script:form.Add_Shown({ $script:input.Focus() })
[void]$script:form.ShowDialog()
