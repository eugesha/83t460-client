[System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer

$prgdir=$PSScriptRoot
$fname=$MyInvocation.MyCommand.Name
$prgname=$PSCommandPath
$PORT=""
$WEBPort=""
$CONF=""
$SERVER=""
$LOG=""
$DATADIR=$env:LOCALAPPDATA\INT\83t460

$sys=sysapicmd -u
$CURRENTLEVEL=$sys[6].split(':')[2]

if ($CURRENTLEVEL -eq "���������� ��������") {$lev=3}
elseif ($CURRENTLEVEL -eq "��������") {$lev=2}
elseif ($CURRENTLEVEL -eq "���") {$lev=1}
elseif ($CURRENTLEVEL -eq "���") {$lev=1}
elseif ($CURRENTLEVEL -eq "����������") {$lev=0}
else {echo "������"}

