Add-Type -AssemblyName PresentationCore, PresentationFramework
$Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Title="CA_REMOVE" Height="450" Width="369" >
    <Grid>
        <Grid.Effect>
            <DropShadowEffect/>
        </Grid.Effect>
        <Grid.Background>
            <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
                <GradientStop Color="#FF23A48F"/>
                <GradientStop Color="#FF093AD2" Offset="1"/>
            </LinearGradientBrush>
        </Grid.Background>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="187*"/>
            <ColumnDefinition Width="182*"/>
        </Grid.ColumnDefinitions>
        <Button Content="Desinstaller" Grid.Column="1" Margin="21,22,21,0"  Height="49" VerticalAlignment="Top" Background="#FFFDB6C9" Name="BDesinstall">
            <Button.Effect>
                <DropShadowEffect/>
            </Button.Effect>
        </Button>
        <Button Content="Lister les programmes" Margin="24,22,23,0" Height="49" VerticalAlignment="Top" FontFamily="Segoe UI" FontWeight="Normal" FontStretch="Normal" FontStyle="Normal" Background="#FFECEFCA" Name="BListe" >
            <Button.Effect>
                <DropShadowEffect/>
            </Button.Effect>
        </Button>
        <ListBox  Grid.ColumnSpan="2" Margin="10,77,10,17" Background="#FFD7F5FF" BorderBrush="White" Name="List1" >
            <ListBox.Effect>
                <DropShadowEffect/>
            </ListBox.Effect>
        </ListBox>
</Grid>
</Window>
"@
# CONTROLS
function FDesinstall(){
[xml]$xmld=(Get-Package -Provider Programs -IncludeWindowsInstaller -Name $List1.SelectedValue).SwidTagText
$QUninstall=$xmld.SoftwareIdentity.Meta.QuietUninstallString | out-string
if ($QUninstall -eq ""){[void] [System.Windows.MessageBox]::Show( "Desinstallation silencieuse impossible" )}
$answer = [System.Windows.MessageBox]::Show( "Souhaitez vous continuer avec la désinstallation standard ?", " Removal Confirmation", "YesNoCancel", "Warning" )
if ($answer -eq "Yes")
{
$NUninstall=$xmld.SoftwareIdentity.Meta.UninstallString | out-string
$Del='"'+$NUninstall.substring(0,$NUninstall.Length-1)+'"'
$mig=$Del | Out-String
try{cmd /c $QUninstall}
catch{cmd /c $NUninstall}
finally{cmd /c $mig}}
else{}
}

function FList(){

$ListeApp=Get-Package -Provider Programs -IncludeWindowsInstaller
$Liste=$ListeApp.Name
Foreach ($item in $Liste)
{
 $List1.Items.Add($item)
 }
$BDesinstall.IsEnabled=$true
}

## SCRIPT

$Window = [Windows.Markup.XamlReader]::Parse($Xaml)

[xml]$xml = $Xaml


$xml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name $_.Name -Value $Window.FindName($_.Name) }


$BDesinstall.IsEnabled=$false
$BDesinstall.Add_Click({FDesinstall $this $_})
$BListe.Add_Click({FList $this $_})


[void]$Window.ShowDialog()
