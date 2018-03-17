$env:HOME = "$($env:HOMEDRIVE)$($env:HOMEPATH)"
$env:EDITOR = 'edit.cmd'
# for latest nvim tui which wont do colours without a hint
$env:COLORTERM='truecolor'
$env:RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src/"

$env:GOPATH="C:/dev/tools/gopath"

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

function Start-PushpayPublic { &'C:\Program Files (x86)\IIS Express\iisexpress.exe' "/config:$(git home)\.vs\config\applicationhost.config" /site:Pushpay.Public }

function Get-LockImages {
    ls "$env:userprofile\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\*" |
        ? length -gt 300000 |
        % {
            $img = new-object -ComObject Wia.ImageFile
            $img.LoadFile($_.fullname)
            if ($img.Width -lt $img.Height) {
                $extraFolder = 'portrait\'
            } else {
                $extraFolder = ''
            }
            cp $_ "C:\Users\Leaf Garland\Pictures\wallpaper\lock\$extraFolder$($_.name).jpg"
        }
}

if (Get-Command pageant -CommandType Application -ErrorAction SilentlyContinue) {
    pageant "$($env:HOME)\.ssh\github_rsa_private.ppk"
    $env:GIT_SSH = (Get-Command plink -CommandType Application)[0].Source
} elseif (test-path "$env:TOOLS\GitExtensions\PuTTY\pageant.exe") {
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
  if (-not $global:AllGitCmds) {
    $global:AllGitCmds = Get-GitCmds | % { @{ Value=$_; Tip=$_ } }
  }

  $global:LastGitAllMatches = $null
  if ($line -match "git( -\S+)* (dofixup|show?)( -\S+)*") {
    $allMatches = git log master..HEAD --pretty=format:"%h|%s" | % { $x=$_.split('|'); @{ Value=$x[0]; Tip=$x[1] } }
  } elseif ($line -match "git( -\S+)* (add|discard)( -\S+)*") {
    $allMatches = git diff --name-status | % { $x=$_.split([char]0x09); @{ Value=$x[1]; Tip=$x[0] } }
  } elseif ($line -match "git( -\S+)* unstage( -\S+)*") {
    $allMatches = git diff --name-status --cached | % { $x=$_.split([char]0x09); @{ Value=$x[1]; Tip=$x[0] } }
  } elseif ($line -match "^git (-\S+ )*(\S+)?$") {
    $allMatches = $AllGitCmds
  } elseif ($line -match "(ori|orig|origi|origin)(/\S+)?$") {
    $allMatches = git for-each-ref --sort=-committerdate --format='%(refname:short)|%(committerdate:relative)' refs/remotes/origin/ | % { $x=$_.split('|'); @{ Value=$x[0]; Tip=$x[1] } }
  } else {
    $allMatches = git for-each-ref --sort=-committerdate --format='%(refname:short)|%(committerdate:relative)' refs/heads/ | % { $x=$_.split('|'); @{ Value=$x[0]; Tip=$x[1] } } 
  }

  if ([string]::isnullorempty($lastword)) {
    $allMatches |
    % { new-object System.Management.Automation.CompletionResult $_.Value, $_.Value, 'Text', $_.Tip }
  } else {
    $allMatches | ? { $_.Value -like "*$lastword*" } |
    % { new-object System.Management.Automation.CompletionResult $_.Value, $_.Value, 'Text', $_.Tip }
  }
}

function ppyarn {
    $febuild = join-path (git home) "febuild"
    if (test-path $febuild) {
        try {
            pushd $febuild
            yarn $args
        }
        finally {
            popd
        }
    } else {
        write-warning "not in repo"
    }
}

function wsl { &"${env:LOCALAPPDATA}\wsltty\bin\mintty.exe" --wsl -o Locale=C -o Charset=UTF-8 /bin/wslbridge -t /usr/bin/fish }

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
$host.PrivateData.ErrorForegroundColor = 'Red'
$host.PrivateData.ErrorBackgroundColor = 'Black'
$host.PrivateData.WarningForegroundColor = 'DarkYellow'
$host.PrivateData.WarningBackgroundColor = 'Black'
function Reset-Colours { $host.ui.rawui.foregroundcolor = 7 }
function Show-Colors { 0..15 | % { Write-Host -NoNewline "["; Write-Host -NoNewLine -BackgroundColor $_ "   "; Write-Host -NoNewLine "] "; write-host ([consolecolor]$_) } }

$isElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

$PA = [char]0xE0B0
$ShowTiming = $false
function Prompt {
    $host.ui.rawui.windowtitle = "PS $(get-location)"

    $waserror = if ($?) {1} else {4}
    Enable-VirtualTerminal

    $lastcmd = get-history -count 1
    $lastcmdtime = $lastcmd.endexecutiontime - $lastcmd.startexecutiontime

    Write-Host -ForegroundColor DarkCyan -nonewline "$(get-location) " 
    $branchName = if (git rev-parse --is-inside-work-tree 2>$null) { git rev-parse --abbrev-ref HEAD }
    if ($branchName) {
        Write-Host -NoNewline -ForegroundColor DarkGreen "$(FitWindow($branchName)) "
    }

    if ($ShowTiming) {
        Write-Host -NoNewline -ForegroundColor DarkYellow "$lastcmdtime "
    }
    elseif ($lastcmdtime.totalseconds -gt 3) {
        Write-Host -NoNewline -ForegroundColor DarkYellow "$(format-timespan($lastcmdtime)) "
    }

    Write-Host ""

    if ($isElevated) {
        Write-Host -ForegroundColor White -BackgroundColor $waserror -NoNewline "ADMIN"
    }
    Write-Host -ForegroundColor $waserror "$PA" -NoNewline

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
Add-Path "C:\dev\tools\jdk\bin"
Add-Path "C:\dev\tools\gopath\bin"

Set-Alias ss select-string
Set-Alias gx gitex
Set-Alias l ls
Set-Alias nvim Invoke-Nvr
Set-Alias vim Invoke-Vim
Set-Alias stree Invoke-SourceTree
Set-Alias vsvar Set-VisualStudioEnvironment
Set-Alias sudo Start-Elevated
Set-Alias de devenv.com
Set-Alias rider 'C:\Program Files\JetBrains\Rider 2017.1.1\bin\rider64.exe'
Set-Alias bc 'bcompare'
set-alias code 'C:\Program Files\Microsoft VS Code Insiders\bin\code-insiders.cmd'
Set-Alias cdb "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\cdb.exe"
Set-Alias windbg "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\windbg.exe"
set-alias python3 "$env:LOCALAPPDATA\Programs\Python\Python35\python.exe"
Set-Alias gitex "$env:TOOLS\GitExtensions\gitex.cmd"
function icdiff { icdiff.py "--cols=$($Host.UI.RawUI.WindowSize.Width)" $args }

function e { Invoke-Expression "$env:EDITOR $args" }
function spe { sudo procexp $args }
function rg { rg.exe --color=auto --type-add xaml:*.xaml --type-add proj:*.*proj --type-add cshtml:*.cshtml --type-add cs:!*.generated.cs --type-add cs:include:cshtml --type-add tsx:*.tsx --type-add ts:include:tsx $args }
function grep() { $input | rg.exe --hidden $args }

Import-Module ZLocation
Set-Alias j Set-ZLocation

Import-Module PSReadLine
Set-PSReadlineOption -BellStyle Visual
Set-PSReadlineOption -ViModeIndicator Cursor
Set-PSReadlineOption -EditMode Windows
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadlineOption -ContinuationPrompt ">> "
Set-PSReadlineOption -ContinuationPromptForegroundColor DarkYellow
Set-PSReadlineOption Operator -ForegroundColor Cyan
Set-PSReadlineOption Parameter -ForegroundColor DarkCyan
Set-PSReadlineOption Type -ForegroundColor Blue
Set-PSReadlineOption String -ForegroundColor DarkGreen
Set-PSReadlineOption Keyword -ForegroundColor Yellow
Set-PSReadlineOption Variable -ForegroundColor Magenta
Set-PSReadlineOption -ShowToolTips
Set-PSReadlineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key Ctrl+n -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Ctrl+q -Function Complete
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
        if (git rev-parse --is-inside-work-tree 2>$null) {
            $choices = git ls-files
        } else {
            $choices = rg --files .
        }
        $choices = $choices | hs
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($choices -join " ")
    }

Set-PSReadlineKeyHandler `
     -Chord 'Ctrl+x' `
     -ScriptBlock {
        $lastCmd = (Get-History -Count 1).CommandLine
        if ($lastCmd.StartsWith('rg')) {
            $choices = invoke-expression "$lastCmd -l"
            $choices = $choices | hs
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($choices -join " ")
        }
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
    if ($env:NVIM_LISTEN_ADDRESS) {
        nvr.py -l $args
        return
    }
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

function Set-VisualStudioEnvironment([string]$Version="*", [string]$Platform="", [switch]$Prerelease=$false) {
  $vswhereArgs = "-latest","-property","installationPath"
  if ($prerelease) { $vswhereArgs = ,"-prerelease" + $vswhereArgs }
  $installationPath = &"${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" $vswhereArgs
  $vsDevCmd = "$installationPath\Common7\Tools\VsDevCmd.bat"
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


function Start-AwsWithVault([ValidateSet("playpen", "playpen-mgmt")]$profile="playpen")
{
    aws-vault exec "$profile" -- $args
}
Set-Alias awsv Start-AwsWithVault
function Start-AwsLocalMetaData { start powershell {cd C:\Dev\git\awslocalmetadata\source\metadata-server\; awsv playpen -- dotnet run} }
