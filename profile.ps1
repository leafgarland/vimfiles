$env:HOME = "$env:HOMEDRIVE$env:HOMEPATH"
$env:EDITOR = 'nvim.exe'
$env:RIPGREP_CONFIG_PATH = "$($env:HOME)/.ripgrep"
# for latest nvim tui which wont do colours without a hint
$env:COLORTERM = 'truecolor'

$env:GOPATH = "C:/dev/tools/gopath"

if ($env:NVIM_CONFIG) {
    # running inside nvim
    $env:EDITOR = 'nvr --remote-wait-silent -l'
}

function edit { Invoke-Expression ([string]::join(' ', (, $env:EDITOR + $args))) }

function Start-PushpayPublic { &'C:\Program Files (x86)\IIS Express\iisexpress.exe' "/config:$(git home)\.vs\config\applicationhost.config" /site:Pushpay.Public }
function pico ($size = 256) { C:\dev\me\pico-8\pico8.exe -width $size+2 -height $size+2 $args }
function d2b($d) { [System.Convert]::ToString($d, 2) }
function d2h($d) { [System.Convert]::ToString($d, 16) }
function b2d([string]$b) { [System.Convert]::ToInt32($b, 2) }
function rgl { rg.exe --color=always --heading -n $args | less -r }

function Update-GitGraphCache { git show-ref -s | git commit-graph write --stdin-commits }

function Get-JiraIssues {
    $json = curl.exe --user "$($env:JIRA_USER):$($env:JIRA_PW)" `
        -sn 'https://pushpay.atlassian.net/rest/api/latest/search?jql=assignee%20%3D%20currentUser()%20AND%20resolution%20%3D%20Unresolved%20AND%20status%20NOT%20IN%20(Closed%2C%20Done%2C%20Backlog)%20AND%20type%20NOT%20IN%20(Epic%2C%20Idea%2C%20Story)&fields=summary'
    $objs = ConvertFrom-Json $json
    $objs.issues | % { "$($_.key)-$($_.fields.summary.tolower() -replace '[^a-zA-Z0-9]','-')" } | sort -Descending
}

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
        cp $_ "$(Resolve-Path ~/pictures/wallpaper/lock)/$extraFolder$($_.name).jpg"
    }
}

# ssh-agent service should be AutomaticDelay, so it runs at startup and ssh-add should have cached previous identities too,
# so the below (or ssh equivalent) should not be needed. Might need to tell git to use the right ssh via $env:GIT_SSH

# if ((Get-Command pageant -CommandType Application -ErrorAction SilentlyContinue) -and (-not (Get-Process pageant -erroraction silentlycontinue))) {
#     pageant "$($env:HOME)\.ssh\github_rsa_private.ppk"
#     $env:GIT_SSH = Resolve-Path (scoop which plink)
# }

$HistoryPath = "~\pshistory.xml"
Register-EngineEvent PowerShell.Exiting -Action { Get-History -Count 3000 | Export-CliXml $HistoryPath} | Out-Null
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
        if ($p -gt 1) { (99999 - $p).tostring("x8") + $_ } else { $_ }
    }
}

Register-ArgumentCompleter -Native -CommandName 'git' -ScriptBlock { param($lastword, $line) 
    if (-not $global:AllGitCmds) {
        $global:AllGitCmds = Get-GitCmds | % { @{ Value = $_; Tip = $_ } }
    }

    $global:LastGitAllMatches = $null
    if ($line -match "git( -\S+)* (dofixup|show?)( -\S+)*") {
        $allMatches = git log master..HEAD --pretty=format:"%h|%s" | % { $x = $_.split('|'); @{ Value = $x[0]; Tip = $x[1] } }
    } elseif ($line -match "git( -\S+)* (add|discard)( -\S+)*") {
        $allMatches = git diff --name-status | % { $x = $_.split([char]0x09); @{ Value = $x[1]; Tip = $x[0] } }
    } elseif ($line -match "git( -\S+)* unstage( -\S+)*") {
        $allMatches = git diff --name-status --cached | % { $x = $_.split([char]0x09); @{ Value = $x[1]; Tip = $x[0] } }
    } elseif ($line -match "git( -\S+)* (checkout|co)( -\S+)* -b") {
        $allMatches = Get-JiraIssues | % { @{ Value = $_; Tip = $_ } }
    } elseif ($line -match "^git (-\S+ )*(\S+)?$") {
        $allMatches = $AllGitCmds
    } elseif ($line -match "(ori|orig|origi|origin)(/\S+)?$") {
        $allMatches = git for-each-ref --sort=-committerdate --format='%(refname:short)|%(committerdate:relative)' refs/remotes/origin/ | % { $x = $_.split('|'); @{ Value = $x[0]; Tip = $x[1] } }
    } else {
        $allMatches = git for-each-ref --sort=-committerdate --format='%(refname:short)|%(committerdate:relative)' refs/heads/ | % { $x = $_.split('|'); @{ Value = $x[0]; Tip = $x[1] } } 
    }

    if ([string]::isnullorempty($lastword)) {
        $allMatches |
            % { new-object System.Management.Automation.CompletionResult $_.Value, $_.Value, 'Text', $_.Tip }
    } else {
        $allMatches | ? { $_.Value -like "*$lastword*" } |
            % { new-object System.Management.Automation.CompletionResult $_.Value, $_.Value, 'Text', $_.Tip }
    }
}

# PowerShell parameter completion shim for the dotnet CLI 
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
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

$host.PrivateData.ProgressForegroundColor = 'Blue'
$host.PrivateData.ProgressBackgroundColor = 'DarkGray'
$host.PrivateData.ErrorForegroundColor = 'Red'
$host.PrivateData.ErrorBackgroundColor = 'Black'
$host.PrivateData.WarningForegroundColor = 'DarkYellow'
$host.PrivateData.WarningBackgroundColor = 'Black'
function Reset-Colours { $host.ui.rawui.foregroundcolor = 7 }
function Show-Colours { 0..7 | % { Write-Host -NoNewLine -BackgroundColor $_ "   "; Write-Host -NoNewLine -BackgroundColor ($_+8) "   "; write-host } }
function Show-Colours24 { "$($ESC=[char]27; $w=$host.ui.rawui.windowsize.width-1; [string]::join('', (0..$w | % { $r=[int](255-($_*255/$w)); $g=[int]($_*510/$w); $b=[int]($_*255/$w); if ($g -gt 255) { $g=510-$g }; "$ESC[48;2;$r;$g;$($b)m$ESC[38;2;$(255-$r);$(255-$g);$(255-$b)m$('/\'[$_%2])$ESC[0m" })))" }

$isElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

$PA = [char]0xE0B0
$BR = [char]0xE0A0
$ShowTiming = $false
function Prompt {
    $waserror = if ($?) {1} else {4}
    $host.ui.rawui.windowtitle = "PS $(get-location)"

    $lastcmd = get-history -count 1
    $lastcmdtime = $lastcmd.endexecutiontime - $lastcmd.startexecutiontime

    Write-Host -ForegroundColor DarkCyan -nonewline "$(get-location) " 
    $branchName = if (git rev-parse --is-inside-work-tree 2>$null) { git rev-parse --abbrev-ref HEAD }
    if ($branchName) {
        Write-Host -NoNewline -ForegroundColor DarkYellow "$BR"
        Write-Host -NoNewline -ForegroundColor DarkGreen "$(FitWindow($branchName)) "
    }

    if ($ShowTiming) {
        Write-Host -NoNewline -ForegroundColor DarkYellow "$lastcmdtime "
    } elseif ($lastcmdtime.totalseconds -gt 3) {
        Write-Host -NoNewline -ForegroundColor DarkYellow "$(format-timespan($lastcmdtime)) "
    }

    Write-Host ""

    if ($isElevated) {
        Write-Host -ForegroundColor White -BackgroundColor $waserror -NoNewline "ADMIN"
    }
    Write-Host -backgroundcolor $waserror -foregroundcolor Black " " -NoNewline
    Write-Host -ForegroundColor $waserror "$PA" -NoNewline

    " "
}

function Add-Path ([switch] $First, [string[]] $Paths) {
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
Add-Path "$env:TOOLS\Utils"
Add-Path "~\.cargo\bin\"
Add-Path "$env:TOOLS\vim\vim80"
Add-Path "$env:TOOLS\vim\Neovim\bin"
Add-Path "$env:TOOLS\BeyondCompare"
Add-Path "C:\dev\tools\jdk\bin"
Add-Path "C:\dev\tools\gopath\bin"
Add-Path 'C:\Program Files (x86)\Meld'

Set-Alias ss select-string
Set-Alias gx gitex
Set-Alias l ls
Set-Alias stree Invoke-SourceTree
Set-Alias vsvar Set-VisualStudioEnvironment
Set-Alias sudo Start-Elevated
Set-Alias de devenv.com
Set-Alias bc 'bcompare'
set-alias code code-insiders.cmd
Set-Alias cdb "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\cdb.exe"
Set-Alias windbg "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\windbg.exe"
Set-Alias gitex "$env:TOOLS\GitExtensions\gitex.cmd"
Set-Alias wsl "C:\Dev\tools\wsl-terminal\open-wsl.exe"
function icdiff { icdiff.py "--cols=$($Host.UI.RawUI.WindowSize.Width)" $args }

function e { Invoke-Expression "$env:EDITOR $args" }
function spe { sudo procexp $args }
function grep() { $input | rg.exe --hidden $args }

Import-Module ZLocation
Set-Alias j Invoke-ZLocation

Import-Module PSReadLine
Set-PSReadlineOption -BellStyle Visual
Set-PSReadlineOption -ViModeIndicator Cursor
Set-PSReadlineOption -EditMode Windows
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadlineOption -ContinuationPrompt ">> "
# Set-PSReadlineOption -ContinuationPromptForegroundColor DarkYellow
# Set-PSReadlineOption Operator -ForegroundColor Cyan
# Set-PSReadlineOption Parameter -ForegroundColor DarkCyan
# Set-PSReadlineOption Type -ForegroundColor Blue
# Set-PSReadlineOption String -ForegroundColor DarkGreen
# Set-PSReadlineOption Keyword -ForegroundColor Yellow
# Set-PSReadlineOption Variable -ForegroundColor Magenta
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
    -Chord 'Ctrl+s,Ctrl+f' `
    -ScriptBlock {
    if (git rev-parse --is-inside-work-tree 2>$null) {
        $choices = git ls-files
    } else {
        $choices = fd
    }
    $choices = $choices | hs
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($choices -join " ")
}

Set-PSReadlineKeyHandler `
    -Chord 'Ctrl+s,Ctrl+b' `
    -ScriptBlock {
    if (git rev-parse --is-inside-work-tree 2>$null) {
        $choices = git recent
    } else {
        $choices = @()
    }
    $choices = $choices | hs
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($choices -join " ")
}

Set-PSReadlineKeyHandler `
    -Chord 'Ctrl+s,Ctrl+o' `
    -ScriptBlock {
    if (git rev-parse --is-inside-work-tree 2>$null) {
        $choices = git for-each-ref --count=30 --sort=-committerdate refs/remotes/origin/ --format='%(refname:short)'
    } else {
        $choices = @()
    }
    $choices = $choices | hs
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($choices -join " ")
}

Set-PSReadlineKeyHandler `
    -Chord 'Ctrl+s,Ctrl+c' `
    -ScriptBlock {
    if (git rev-parse --is-inside-work-tree 2>$null) {
        $choices = git log master..HEAD --format='format:%h %s'
    } else {
        $choices = @()
    }
    $choices = $choices | hs | % { ($_ -split " ")[0] }
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($choices -join " ")
}

Set-PSReadlineKeyHandler `
    -Chord 'Ctrl+s,Ctrl+j' `
    -ScriptBlock {
    $choices = Get-JiraIssues | hs | % { ($_ -split " ")[0] }
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

function Start-Elevated($Command = "powershell.exe", $Args) {
    if ($Args) {
        Start-Process -Verb runAs -workingdirectory $pwd -FilePath $Command -Args:$Args
    } else {
        Start-Process -Verb runAs -workingdirectory $pwd -FilePath $Command
    }
}

function Get-PathFor([System.EnvironmentVariableTarget]$target) {
    [environment]::GetEnvironmentVariable("Path", $target).Split(";") |
        % { [pscustomobject]@{ Path = $_; Target = $target } }
}

function Get-Path {
    $paths = @{}
    (Get-PathFor Process) +
    (Get-PathFor User) +
    (Get-PathFor Machine) |
        % { $paths[$_.Path] = $_ }
    $paths.Values | sort Target
}

function Invoke-Nvr([switch]$Tab, [switch]$Wait) {
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
    $vim = 'vim.exe'
    $gvim = 'gvim.exe'
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
    if ($ts.Hours -gt 0) { $format += "h\h\ " }
    if ($ts.Minutes -gt 0) { $format += "m\m\ " }
    $format += "s\s"
    $ts.ToString($format)
}

function Set-VisualStudioEnvironment([string]$Version = "*", [string]$Platform = "", [switch]$Prerelease = $false) {
    $vswArgs = arr -latest -property installationPath "$(if ($Prerelease) {'-prerelease'})"
    $vsDevCmd = Resolve-Path "$(& "${env:ProgramFiles(x86)}/Microsoft Visual Studio/Installer/vswhere.exe" $vswArgs)/Common7/Tools/VsDevCmd.bat"
    $output = cmd /c "`"$vsDevCmd`" -arch=$Platform 2>&1 && set"
    foreach ($line in $output) {
        if ($line -match '^([^=]+)=(.*)') {
            [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
        }
    }
}


function Start-AwsWithVault([ValidateSet("playpen", "playpen-mgmt")]$profile = "playpen") {
    aws-vault exec "$profile" -- $args
}
Set-Alias awsv Start-AwsWithVault
function Start-AwsLocalMetaData { start powershell {cd C:\Dev\git\awslocalmetadata\source\metadata-server\; awsv playpen -- dotnet run} }
