$global:PsGetDestinationModulePath = "C:\Dev\Tools\PSModules"
$env:PSModulePath = $global:PsGetDestinationModulePath + ";" + $env:PSModulePath

# Make scripts run within powershell, not in own cmd window
$env:PATHEXT += ";.PY;.ERL"

Remove-Item -ErrorAction Ignore Alias:Curl
Remove-Item -ErrorAction Ignore Alias:WGet
Remove-Item -Force -ErrorAction Ignore Alias:gl

function TabExpansion($line, $lastword) {
  switch ($lastword) {
      "mvu" { "mvn -U process-resources "; break }
      "mvv" { "mvn versions:display-dependency-updates "; break }
  }
}

import-module poshgit2
function gs { git status -sb $args }
function gl { git log $args }
function gll { git logmore $args }
function gl1 { git log1 $args }

$rustSrcPath = "C:\Dev\Tools\rust\rustc-1.11.0\src"
if (test-path $rustSrcPath) {
    $env:RUST_SRC_PATH=$rustSrcPath
}

# $env:_NT_SYMBOL_PATH="SRV*c:\dev\tmp\symbols*http://msdl.microsoft.com/download/symbols"
$env:_NT_DEBUGGER_EXTENSION_PATH="C:\dev\tools\debuggers\sosex_64;C:\dev\tools\Debuggers\SOS-4.0"

function Out-File($filepath, $encoding, [switch]$append) {
    $input | microsoft.powershell.utility\out-file $filepath -encoding utf8 -append:$append
}

function Prompt {
  $waserror = if ($?) {
    [system.consolecolor]"green"
  } else {
    [system.consolecolor]"red"
  }

  $lastcmd = get-history -count 1
  $lastcmdtime = $lastcmd.endexecutiontime - $lastcmd.startexecutiontime

  Write-Host -foregroundcolor darkcyan (get-location) -nonewline
  Write-RepositoryStatus

  if ($global:ShowTiming) {
    Write-Host -foregroundcolor yellow " $($lastcmdtime)" -nonewline
  }
  elseif ($lastcmdtime.totalseconds -gt 3) {
    Write-Host -foregroundcolor yellow " $(format-timespan($lastcmdtime))" -nonewline
  }
  Write-Host
  Write-Host -foregroundcolor $waserror ">" -nonewline

  $host.ui.rawui.windowtitle = "PS $(get-location)"

  " "
}

function Add-Path ([switch] $First, [string[]] $Paths){
  $Paths |
    ? { $env:path -notmatch "$([regex]::escape($_))(;|$)" } |
    % { $env:path = if ($First) { $_ + ";" + $env:path } else { $env:path + ";" + $_ } }
}

function arr { $args }
function d2o([HashTable]$dictionary) { new-object -typename psobject -property $dictionary }
filter asXml { [xml](cat $_) }

$env:LEIN_FAST_TRAMPOLINE="y"
function Start-CljsBuild()
{
  lein trampoline cljsbuild $args
}
Set-Alias cljsbuild Start-CljsBuild
Add-Path -First "c:/dev/Tools/Python27/"
Add-Path -First "c:/dev/Tools/Python34/"
Add-Path "C:\Dev\Tools\PSScripts"
Add-Path "C:\Dev\Tools\Utils\"
Add-Path "C:\Users\garlandl\.cargo\bin\"
Add-Path "C:\Users\garlandl\AppData\Local\Pandoc"
Add-Path "C:\Dev\Tools\vim\vim"
Add-Path "C:\Dev\Tools\emacs\bin"
Add-Path "C:\Dev\Tools\maven\bin"
Add-Path "C:\Dev\Tools\ruby200\bin"
Add-Path "C:\Program Files\Mercurial"
Add-Path "C:\Program Files (x86)\Nomura\Desktop\DesktopCoordinator\Service\"
Add-Path "C:\Program Files (x86)\Nomura\Desktop\Installs\Organizer"

Set-Alias l ls
Set-Alias vim Invoke-NVim
Set-Alias tsvn Invoke-TortoiseSvn
Set-Alias stree Invoke-SourceTree
Set-Alias vsvar Set-VisualStudioEnvironment
Set-Alias sudo Start-Elevated
Set-Alias de devenv.com
Set-Alias bc 'C:\Program Files (x86)\Beyond Compare 3\BComp.com'
Set-Alias code "C:\Program Files (x86)\Microsoft VS Code\Code.exe"
Set-Alias cdb "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\cdb.exe"
Set-Alias windbg "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\windbg.exe"

function spe { sudo procexp $args }
function rg { rg.exe --type-add xaml:*.xaml --type-add proj:*.*proj -SH $args }

Import-Module Jump.Location
function jj ([switch]$All) {
  [System.IO.DirectoryInfo](jumpstat -First:(-not $All) $args).Path
}

function em { emacsclient --alternate-editor=runemacs --quiet --no-wait $args }

Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadlineOption -ContinuationPrompt "→ "
Set-PSReadlineOption -ContinuationPromptForegroundColor DarkYellow
Set-PSReadlineOption Operator -ForegroundColor Cyan
Set-PSReadlineOption Parameter -ForegroundColor DarkCyan
Set-PSReadlineOption Type -ForegroundColor Blue
Set-PSReadlineOption String -ForegroundColor Magenta
Set-PSReadlineOption -ShowToolTips
Set-PSReadlineKeyHandler -Key Ctrl+P -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key Ctrl+N -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Ctrl+Q -Function TabCompleteNext
Set-PSReadlineKeyHandler -Key Ctrl+Shift+Q -Function TabCompletePrevious
Set-PSReadlineKeyHandler -Key Alt+D -Function ShellKillWord
Set-PSReadlineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
Set-PSReadlineKeyHandler -Key Alt+B -Function ShellBackwardWord
Set-PSReadlineKeyHandler -Key Alt+F -Function ShellForwardWord
Set-PSReadlineKeyHandler -Key Shift+Alt+B -Function SelectShellBackwardWord
Set-PSReadlineKeyHandler -Key Shift+Alt+F -Function SelectShellForwardWord
Set-PSReadlineKeyHandler -Key Ctrl+V -Function Paste
Set-PSReadlineKeyHandler -Key Ctrl+5 -Function GotoBrace
Set-PSReadlineKeyHandler -Key Ctrl+Alt+s -Function CaptureScreen
Set-PSReadlineOption -MaximumHistoryCount 200000

function Start-Elevated {
  Start-Process -Verb runAs $args[0]
}

function Get-PathFor([System.EnvironmentVariableTarget]$target) {
  [environment]::GetEnvironmentVariable("Path", $target).Split(";") |
  % { [pscustomobject]@{ Path=$_; Target=$target } }
}

function Get-Path {
  $paths = @{}
  (Get-PathFor Process) +
    (Get-PathFor User) +
    (Get-PathFor Machine) |
    % { $paths[$_.Path] = $_ }
  $paths.Values | sort Target
}

function Invoke-NVim([switch]$Tab, [switch]$Wait)
{
    # $vimInstall = "C:\Dev\Tools\vim\Neovim-equalsraf-tb-mingw"
    $vimInstall = "C:\Dev\Tools\vim\Neovim-master"
    $files = $args | ? { $_ -notlike "-*" }
    $otherArgs = $args | ? { $_ -like "-*" }
    if ($files) {
        $remote = '--remote'
        $remote = if ($Tab) { $remote + '-tab' } else { $remote }
        $remote = if ($Wait) { $remote + '-wait' } else { $remote }
    } else {
        $remote = ''
    }
    $nvims = [System.IO.Directory]::GetFiles("\\.\pipe\") | select-string nvim
    if ($nvims) {
        python.exe c:\dev\tools\python35\scripts\nvr.py --servername $nvims[0] -f $otherArgs $remote $files
    } else {
        Add-Path "$vimInstall\bin"
        $env:VIM = "$vimInstall\share\nvim"
        $env:VIMRUNTIME = "$vimInstall\share\nvim\runtime"
        C:\dev\tools\vim\Neovim-Qt\bin\nvim-qt.exe --nvim "$vimInstall\bin\nvim.exe" --geometry 80x50 -- $args
    }
}

function Invoke-Vim([switch]$Tab, [switch]$Wait) {
  $vimInstall="c:\dev\tools\vim\vim"
  if ($global:VimServerName) { $serverName = $global:VimServerName }
  else { $serverName = "GVIM" }
  $servers = (vim.exe --noplugin -u NORC --serverlist) | ? { $_ -eq $serverName }
  if ($args) {
    $files = $args | ? { $_ -notlike "-*" }
    $otherArgs = $args | ? { $_ -like "-*" }
    $remote = '--remote'
    $remote = if ($Tab) { $remote + '-tab' } else { $remote }
    $remote = if ($Wait) { $remote + '-wait' } else { $remote }
    $remote += '-silent'
    if ($servers) {
      vim.exe $otherArgs --servername $serverName -c "call remote_foreground('$serverName')" $remote $files
    } else {
      gvim.exe $otherArgs --servername $serverName $files
    }
  } else {
    if ($servers) {
      vim.exe --noplugin -u NORC -c "call remote_foreground('$serverName')" -c "quit"
    } else {
      $env:VIM = "$vimInstall"
      $env:VIMRUNTIME = "$vimInstall" 
      gvim.exe --servername $serverName
    }
  }
}

function Invoke-SourceTree(
[ValidateSet('clone', 'status', 'log', 'search', 'filelog', 'commit')]$cmd)
{
  $stree = 'C:\Program Files (x86)\Atlassian\SourceTree\sourcetree.exe'
  & $stree $cmd $args
}

function Invoke-TortoiseSvn(
[ValidateSet('blame','merge','log','resolve','status','commit','browse','update','add','cleanup','copy','diff')]$cmd,
  $path=".") 
{
  $acmd = $cmd
  if ($acmd -eq "status") { $acmd = "repostatus" }
  if ($acmd -eq "browse") { $acmd = "repobrowser" }
  & 'C:\Program Files\TortoiseSVN\SVN\bin\TortoiseProc.exe' /command:$acmd /path:$path
}

function Set-SvnDepth($Path=".", [ValidateSet('infinity','files','immediates','exclude','empty')]$Depth)
{
  svn update --parents --set-depth=$Depth $Path
}

function svninc($Path) { Set-SvnDepth -Path $Path -Depth infinity }
function svnexc($Path) { Set-SvnDepth -Path $Path -Depth exclude }

function Invoke-Maven(
  [ValidateSet('process-resources',
               'versions:display-dependency-updates',
               'dependency:list',
               'help:effective-pom -Doutput=effective-pom.xml',
               'compile',
               'package',
               'sonar',
               'clean',
               'test')]$cmd) {
  mvn $cmd $args
}

function Open-RiskViewer(
    [String]
    [ValidateSet("Development",
                 "Development.Staging",
                 "Staging")]
    $Env = "Development",
    [String] $User) {
    if ($User) {
        $instance = "$User($User)"
    } else {
        $instance = "default"
    }
    stk openwindow "stk://$Env.Onyx-Risk-Viewer.$instance/OnyxRisk"
}
Set-Alias orv Open-RiskViewer

function Stk-ListWindows {
  (stk listwindows | select -Skip 1) | % {$_.split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)[0]}
}

function orv-users ($Env="Staging", $Users, $App = "Onyx-Risk-Viewer", [switch]$NewWindow) {
  $wid = Stk-ListWindows | select -Last 1
  $NewWindow = $NewWindow -or $wids.length -eq 0
  foreach ($user in $Users) {
    if ($NewWindow) {
      stk openwindow "stk://$Env.$App.$user($user)/OnyxRisk"
      $wid = Stk-ListWindows | select -Last 1
      $NewWindow = $false
    } else {
      stk addtab $wid "stk://$Env.$App.$user($user)/OnyxRisk" 
    }
  }
}
# $u = ($users | select -Skip 5 -First 5); orv-users -Users $u -NewWindow; orv-users -Env Production -Users $u -NewWindow
# ps *content* | ? FileVersion -match "8.2*" | measure PrivateMemorySize -Sum

function Format-TimeSpan([TimeSpan]$ts) {
  $format = ""
  if ($ts.Hours -gt 0)   { $format += "h\h\ " }
  if ($ts.Minutes -gt 0) { $format += "m\m\ " }
  $format += "s\s"
  $ts.ToString($format)
}

function Set-VisualStudioEnvironment([string]$Version="*", [string]$Platform="") {
  $vsenvvar = "env:\VS$($Version)0COMNTOOLS"
  $command = "$((ls $vsenvvar | sort name | select -last 1).value)..\..\VC\vcvarsall.bat"
  foreach($line in cmd /c "`"$command`" $Platform 2>&1 && set") {
    if ($line -match '^([^=]+)=(.*)') {
      [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
    }
  }
}

