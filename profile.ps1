$env:HOME = "$($env:HOMEDRIVE)$($env:HOMEPATH)"
# $env:EDITOR = 'nvim-qt.exe -qwindowgeometry "1000x810"'
$env:EDITOR = 'nvim.exe'

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$OutputEncoding = [System.Text.Encoding]::UTF8

Add-Type -MemberDefinition @"
[DllImport("kernel32.dll", SetLastError=true)]
public static extern bool SetConsoleMode(IntPtr hConsoleHandle, int mode);
[DllImport("kernel32.dll", SetLastError=true)]
public static extern IntPtr GetStdHandle(int handle);
[DllImport("kernel32.dll", SetLastError=true)]
public static extern bool GetConsoleMode(IntPtr handle, out int mode);
"@ -Namespace Profile -Name NativeMethods

function Enable-VirtualTerminal() {
    $Handle = [Profile.NativeMethods]::GetStdHandle(-11) # STDOUT
    $Mode = 0
    $Result = [Profile.NativeMethods]::GetConsoleMode($Handle, [ref]$Mode)
    if (($Mode -band 4) -ne 4) {
        $Mode = $Mode -bor 4 # ENABLE_VT
        $Result = [Profile.NativeMethods]::SetConsoleMode($Handle, $Mode)
    }
}

function setbg([byte]$r, [byte]$g, [byte]$b) { "$([char]0x1b)[48;2;${r};${g};${b}m" }
function setbg([object[]]$c) { "$([char]0x1b)[48;2;$($c[0]);$($c[1]);$($c[2])m" }
function setfg([byte]$r, [byte]$g, [byte]$b) { "$([char]0x1b)[38;2;${r};${g};${b}m" }
function setfg([object[]]$c) { "$([char]0x1b)[38;2;$($c[0]);$($c[1]);$($c[2])m" }
function resetbgfg() { "$([char]0x1b)[0m" }
$dark0_hard      =  29, 32, 33
$dark0           =  40, 40, 40
$dark0_soft      =  50, 48, 47
$dark1           =  60, 56, 54
$dark2           =  80, 73, 69
$dark3           = 102, 92, 84
$dark4           = 124,111,100
$gray_245        = 146,131,116
$gray_244        = 146,131,116
$light0_hard     = 249,245,215
$light0          = 251,241,199
$light0_soft     = 242,229,188
$light1          = 235,219,178
$light2          = 213,196,161
$light3          = 189,174,147
$light4          = 168,153,132
$bright_red      = 251, 73, 52
$bright_green    = 184,187, 38
$bright_yellow   = 250,189, 47
$bright_blue     = 131,165,152
$bright_purple   = 211,134,155
$bright_aqua     = 142,192,124
$bright_orange   = 254,128, 25

$neutral_red     = 204, 36, 29
$neutral_green   = 152,151, 26
$neutral_yellow  = 215,153, 33
$neutral_blue    =  69,133,136
$neutral_purple  = 177, 98,134
$neutral_aqua    = 104,157,106
$neutral_orange  = 214, 93, 14

$faded_red       = 157,  0,  6
$faded_green     = 121,116, 14
$faded_yellow    = 181,118, 20
$faded_blue      =   7,102,120
$faded_purple    = 143, 63,113
$faded_aqua      =  66,123, 88
$faded_orange    = 175, 58,  3

if (test-path "$env:TOOLS\GitExtensions\PuTTY\pageant.exe") {
    & "$env:TOOLS\GitExtensions\PuTTY\pageant.exe" "$($env:HOME)\.ssh\github_rsa_private.ppk"
    $env:GIT_SSH="$env:TOOLS\GitExtensions\PuTTY\plink.exe"
}

$HistoryPath = "~\pshistory.xml"
Register-EngineEvent PowerShell.Exiting -Action { Get-History -Count 2000 | Export-CliXml $HistoryPath} | Out-Null
if (Test-Path $HistoryPath) {
    Import-CliXml $HistoryPath | Add-History
}

# Make scripts run within powershell, not in own cmd window
$env:PATHEXT += ";.PY;.ERL"

Remove-Item -ErrorAction Ignore Alias:Curl
Remove-Item -ErrorAction Ignore Alias:WGet
Remove-Item -Force -ErrorAction Ignore Alias:gl

function TabExpansion($line, $lastword) {
  switch ($line) {
      "g" { "git "; break }
      "go" { "git checkout "; break }
      "gg" { "git gui "; break }
      "gs" { "git status -sb "; break }
      "gl" { "git log "; break }
      "gll" { "git logmore "; break }
      "gl1" { "git log1 "; break }
      "glm" { "git lm "; break }
      "grc" { "git rebase --continue "; break }
      "gk" { "gitk "; break }
  }
}

function gs { git status -sb $args }
function gl { git log $args }
function gll { git logmore $args }
function gl1 { git log1 $args }
function glm { git lm $args }
function go { git checkout $args }
function gg { git gui $args }
function grc { git rebase --continue $args }
function gk { gitk $args }

function Get-GitCmds {
    $UsedGitCmds = (Get-History).commandline |
        sls "^git (?:-\S+ )*(\S+)" |
        % { $_.matches.groups[1].value } |
        group |
        select name, count
    $AllGitCmds = git help -a |
        ? { $_ -match "^  [a-z]" } |
        % { $_.split(' ', [System.StringSplitOptions]::RemoveEmptyEntries) }
    $AllGitAliases = git config -l |
        sls "alias\.(\w+)" |
        % { $_.matches.groups[1].value }
    $AllGitCmds + $AllGitAliases |
        sort -unique {
            $p = ($UsedGitCmds | ? Name -eq $_).Count
            if ($p -gt 1) { (99999-$p).tostring("x8") + $_ } else { $_ }
        }
}

Register-ArgumentCompleter -Native -CommandName 'git' -ScriptBlock { param($lastword, $line)
  if (-not $global:AllGitCmds) { $global:AllGitCmds = Get-GitCmds }
  if ($line -match "^git (-\S+ )*\S+$") {
    $AllGitCmds |
    ? { $_ -like "$lastword*" } |
    % { new-object System.Management.Automation.CompletionResult $_, $_, 'Text', $_ }
  } else {
    git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ |
    ? { $_ -like "$lastword*" } |
    % { new-object System.Management.Automation.CompletionResult $_, $_, 'Text', $_ }
  }
}

function ppgulp {
    $febuild = join-path (git home) "febuild"
    if (test-path $febuild) {
        try {
            pushd $febuild
            ./node_modules/.bin/gulp $args
        }
        finally {
            popd
        }
    } else {
        write-warning "not in repo"
    }
}

function wsl { &"${env:LOCALAPPDATA}\wsltty\bin\mintty.exe" --wsl -o Locale=C -o Charset=UTF-8 -i "${env:LOCALAPPDATA}\lxss\bash.ico" /bin/wslbridge -t /usr/bin/fish }

# $env:_NT_SYMBOL_PATH="SRV*c:\dev\tmp\symbols*http://msdl.microsoft.com/download/symbols"
# $env:_NT_DEBUGGER_EXTENSION_PATH="$env:TOOLS\debuggers\sosex_64;$env:TOOLS\Debuggers\SOS-4.0"

function FitWindow($text) {
    $rawui = $host.ui.rawui
    $cols = $rawui.windowsize.width
    $x = $rawui.cursorposition.x
    $remaining = $cols - $x - 5
    if ($text.length -gt $remaining) {
        $text = $text.substring(0, $remaining) + "$([char]0x2026)"
    }
    $text
}

$host.PrivateData.ProgressForegroundColor = 'White'
$host.PrivateData.ProgressBackgroundColor = 'DarkBlue'
$host.PrivateData.ErrorForegroundColor = 'White'
$host.PrivateData.ErrorBackgroundColor = 'DarkRed'
$host.PrivateData.WarningForegroundColor = 'DarkYellow'
$host.PrivateData.WarningBackgroundColor = 'DarkRed'
function Reset-Colours { $host.ui.rawui.foregroundcolor = 7 }

$isElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

$PA = [char]0xE0B0
$ShowTiming = $false
function Prompt {
    $waserror = if ($?) {1,9} else {4,12}
    Enable-VirtualTerminal

    $lastcmd = get-history -count 1
    $lastcmdtime = $lastcmd.endexecutiontime - $lastcmd.startexecutiontime

    Write-Host "$(setbg $dark2)$(setfg $neutral_aqua)$(get-location)" -nonewline
    $lastbg = $dark2
    $branchName = if (git rev-parse --is-inside-work-tree 2>$null) { git rev-parse --abbrev-ref HEAD }
    if ($branchName) {
        Write-Host -nonewline "$(setbg $dark1)$(setfg $dark2)$PA$(setfg $neutral_yellow)$(FitWindow($branchName))"
        $lastbg = $dark1
    }

    if ($ShowTiming) {
        Write-Host "$(setbg $dark1; setfg $bright_yellow) $lastcmdtime" -nonewline
        $lastbg = $dark1
    }
    elseif ($lastcmdtime.totalseconds -gt 3) {
        Write-Host "$(setbg $dark1; setfg $bright_yellow) $(format-timespan($lastcmdtime))" -nonewline
        $lastbg = $dark1
    }

    Write-Host "$(setfg $lastbg)$PA"

    if ($isElevated) {
        Write-Host -ForegroundColor White -backgroundcolor $waserror[0] -NoNewline "ADMIN"
    }
    Write-Host -foregroundcolor $waserror[0] "$PA" -nonewline
    # Write-Host -foregroundcolor $waserror[1] "$PA" -nonewline

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

Add-Path -First "$env:TOOLS\Python27\"
Add-Path "$env:LOCALAPPDATA\Programs\Python\Python35"
Add-Path "$env:TOOLS\PSScripts"
Add-Path "$env:TOOLS\Yarn\bin"
Add-Path "$env:TOOLS\Utils"
Add-Path "~\.cargo\bin\"
Add-Path "$env:TOOLS\vim\vim80"
Add-Path "$env:TOOLS\vim\Neovim\bin"
Add-Path "$env:TOOLS\BeyondCompare"

Set-Alias ss select-string
Set-Alias gx gitex
Set-Alias l ls
Set-Alias nvim Invoke-Nvr
Set-Alias vim Invoke-Vim
Set-Alias stree Invoke-SourceTree
Set-Alias vsvar Set-VisualStudioEnvironment
Set-Alias sudo Start-Elevated
Set-Alias de devenv.com
Set-Alias bc 'bcompare'
set-alias code 'C:\Program Files (x86)\Microsoft VS Code Insiders\bin\code-insiders.cmd'
Set-Alias cdb "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\cdb.exe"
Set-Alias windbg "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\windbg.exe"
set-alias python3 "$env:LOCALAPPDATA\Programs\Python\Python35\python.exe"
Set-Alias gitex "$env:TOOLS\GitExtensions\gitex.cmd"
function icdiff { icdiff.py "--cols=$($Host.UI.RawUI.WindowSize.Width)" $args }

function e { Invoke-Expression "$env:EDITOR $args" }
function spe { sudo procexp $args }
function rg { rg.exe --color=ansi --type-add xaml:*.xaml --type-add proj:*.*proj --type-add cshtml:*.cshtml --type-add cs:!*.generated.cs --type-add cs:include:cshtml $args }
function grep() { $input | rg.exe --hidden $args }

Import-Module Jump.Location
function jj ([switch]$All) {
  [System.IO.DirectoryInfo](jumpstat -First:(-not $All) $args).Path
}

Import-Module PSReadLine
Set-PSReadlineOption -BellStyle Visual
Set-PSReadlineOption -EditMode Emacs -ViModeIndicator Cursor
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadlineOption -ContinuationPrompt ">> "
Set-PSReadlineOption -ContinuationPromptForegroundColor DarkYellow
Set-PSReadlineOption Operator -ForegroundColor Cyan
Set-PSReadlineOption Parameter -ForegroundColor DarkCyan
Set-PSReadlineOption Type -ForegroundColor Blue
Set-PSReadlineOption String -ForegroundColor Magenta
Set-PSReadlineOption -ShowToolTips
Set-PSReadlineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key Ctrl+n -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Ctrl+q -Function TabCompleteNext
Set-PSReadlineKeyHandler -Key Ctrl+Shift+q -Function TabCompletePrevious
Set-PSReadlineKeyHandler -Key Alt+d -Function ShellKillWord
Set-PSReadlineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
Set-PSReadlineKeyHandler -Key Alt+b -Function ShellBackwardWord
Set-PSReadlineKeyHandler -Key Alt+f -Function ShellForwardWord
Set-PSReadlineKeyHandler -Key Shift+Alt+b -Function SelectShellBackwardWord
Set-PSReadlineKeyHandler -Key Shift+Alt+f -Function SelectShellForwardWord
Set-PSReadlineKeyHandler -Key Ctrl+v -Function Paste
Set-PSReadlineKeyHandler -Key Ctrl+Alt+s -Function CaptureScreen
Set-PSReadlineKeyHandler -Key Ctrl+5 -Function GotoBrace
Set-PSReadlineOption -MaximumHistoryCount 200000
Set-PSReadlineKeyHandler `
     -Chord 'Ctrl+s' `
     -ScriptBlock {
         $choices = $(rg --files . | hs)
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($choices -join " ")
    }

function Start-Elevated($Command="powershell.exe", $Args) {
  if ($Args) {
    Start-Process -Verb runAs -workingdirectory $pwd -FilePath $Command -Args:$Args
  } else {
    Start-Process -Verb runAs -workingdirectory $pwd -FilePath $Command
  }
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

function Invoke-Nvr([switch]$Tab, [switch]$Wait)
{
    rm env:VIM -ErrorAction SilentlyContinue
    rm env:VIMRUNTIME -ErrorAction SilentlyContinue
    $remote = if ($args) { '--remote-silent' } else { '' }
    $remote = if ($Tab) { $remote + '-tab' } else { $remote }
    $remote = if ($Wait) { $remote + '-wait' } else { $remote }
    python3 $env:DOTFILES\tools\nvr.py -f $remote $args
}

function Invoke-Vim([switch]$Tab, [switch]$Wait) {
  $vimInstall="$env:TOOLS\vim\vim80"
  $vim=join-path $vimInstall 'vim.exe'
  $gvim=join-path $vimInstall 'gvim.exe'
  if ($global:VimServerName) { $serverName = $global:VimServerName }
  else { $serverName = "GVIM" }
  $servers = (& $vim --noplugin -u NORC --serverlist) | ? { $_ -eq $serverName }
  if ($args) {
    $files = $args | ? { $_ -notlike "-*" }
    $otherArgs = $args | ? { $_ -like "-*" }
    $remote = '--remote'
    $remote = if ($Tab) { $remote + '-tab' } else { $remote }
    $remote = if ($Wait) { $remote + '-wait' } else { $remote }
    $remote += '-silent'
    if ($servers) {
      & $vim $otherArgs --servername $serverName -c "call remote_foreground('$serverName')" $remote $files
    } else {
      & $gvim $otherArgs --servername $serverName $files
    }
  } else {
    if ($servers) {
      & $vim --noplugin -u NORC -c "call remote_foreground('$serverName')" -c "quit"
    } else {
      $env:VIM = "$vimInstall"
      $env:VIMRUNTIME = "$vimInstall" 
      & $gvim --servername $serverName
    }
  }
}

function Format-TimeSpan([TimeSpan]$ts) {
  $format = ""
  if ($ts.Hours -gt 0)   { $format += "h\h\ " }
  if ($ts.Minutes -gt 0) { $format += "m\m\ " }
  $format += "s\s"
  $ts.ToString($format)
}

function Set-VisualStudioEnvironment([string]$Version="*", [string]$Platform="") {
  $vsDevCmd = "C:\Program Files (x86)\Microsoft Visual Studio\$Version\*\Common7\Tools\VsDevCmd.bat"
  if (test-path $vsDevCmd) {
    $command = Resolve-Path $vsDevCmd
    $output = cmd /c "`"$command`" -arch=$Platform 2>&1 && set"
  } else {
    $vsenvvar = "env:\VS$($Version)0COMNTOOLS"
    $command = "$((ls $vsenvvar | sort name | select -last 1).value)vsvars32.bat"
    $output = cmd /c "`"$command`" $Platform 2>&1 && set"
  }
  foreach($line in $output) {
    if ($line -match '^([^=]+)=(.*)') {
      [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
    }
  }
}
