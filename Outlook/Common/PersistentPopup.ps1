param(
    [Parameter(
        Mandatory,
        Position = 0
    )][string]$Title,
    [Parameter(
        Mandatory,
        Position = 1
    )][string]$Message,
    [string]$Color = '#D32F2F'  # red
)

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase
Add-Type -AssemblyName System.Windows.Forms

# Get working area (excludes taskbar)
$wa = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea

# WPF Window (borderless, always on top)
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        WindowStyle="None"
        ResizeMode="NoResize"
        ShowInTaskbar="False"
        Topmost="True"
        Width="360" Height="180"
        Background="#FF1E1E1E"
        AllowsTransparency="True"
        Opacity="0.7">
  <Border CornerRadius="10" BorderBrush="#55000000" BorderThickness="1" Padding="12">
    <Grid>
      <Grid.RowDefinitions>
        <RowDefinition Height="Auto"/>
        <RowDefinition Height="*"/>
        <RowDefinition Height="Auto"/>
      </Grid.RowDefinitions>

      <StackPanel Orientation="Horizontal" Grid.Row="0" Margin="0,0,0,6">
        <Ellipse Name="ellipseColor" Width="10" Height="10" Margin="0,4,8,0"/>
        <TextBlock Name="txtTitle" Foreground="White" FontSize="14" FontWeight="SemiBold"/>
      </StackPanel>

      <TextBlock Name="txtMessage" Grid.Row="1"
                 Foreground="#FFD6D6D6" FontSize="12" TextWrapping="Wrap"/>

      <StackPanel Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,10,0,0">
        <!--
        <Button Name="btnCopy" Content="Copy" Width="70" Margin="0,0,8,0"/>-->
        <Button Name="btnClose" Content="Close" Width="70"/>
      </StackPanel>
    </Grid>
  </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$win = [Windows.Markup.XamlReader]::Load($reader)

# Set text
$win.FindName("txtTitle").Text = $Title
$win.FindName("txtMessage").Text = $Message
# Set ellipse color
$ellipse = $win.FindName("ellipseColor")
$ellipse.Fill = [Windows.Media.BrushConverter]::new().ConvertFromString($Color)

# Position bottom-right
$win.Left = $wa.Right - $win.Width - 12
$win.Top  = $wa.Bottom - $win.Height - 12

# Button handlers
$win.FindName("btnClose").Add_Click({ $win.Close() })
#$win.FindName("btnCopy").Add_Click({
#    [System.Windows.Clipboard]::SetText("$Title`r`n$Message")
#})

# Optional: play a sound
[System.Media.SystemSounds]::Exclamation.Play()

# Show it (blocks until closed)
$null = $win.ShowDialog()
