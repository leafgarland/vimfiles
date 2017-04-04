$env:HOME = "$($env:HOMEDRIVE)$($env:HOMEPATH)"
# $env:EDITOR = 'nvim-qt.exe -qwindowgeometry "1000x810"'
$env:EDITOR = 'gvim'

& "$env:TOOLS\GitExtensions\PuTTY\pageant.exe" "$($env:HOME)\.ssh\github_rsa_private.ppk"
$env:GIT_SSH="$env:TOOLS\GitExtensions\PuTTY\plink.exe"

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
      "gs" { "git status -sb "; break }
      "gl" { "git log "; break }
      "gll" { "git logmore "; break }
      "gl1" { "git log1 "; break }
      "glm" { "git lm "; break }
      "grc" { "git rebase --continue "; break }
  }
}

function gs { git status -sb $args }
function gl { git log $args }
function gll { git logmore $args }
function gl1 { git log1 $args }
function glm { git lm $args }
function go { git checkout $args }

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
    git for-each-ref --format='%(refname:short)' refs/heads/ |
    sort |
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

# $env:_NT_SYMBOL_PATH="SRV*c:\dev\tmp\symbols*http://msdl.microsoft.com/download/symbols"
# $env:_NT_DEBUGGER_EXTENSION_PATH="$env:TOOLS\debuggers\sosex_64;$env:TOOLS\Debuggers\SOS-4.0"

$isElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
$ShowTiming = false
function Prompt {
    $waserror = if ($?) { 1,9 } else { 4,12 }

    $lastcmd = get-history -count 1
    $lastcmdtime = $lastcmd.endexecutiontime - $lastcmd.startexecutiontime

    Write-Host -foregroundcolor darkcyan (get-location) -nonewline
    $branchName = if (Test-Path ./.git) { git rev-parse --abbrev-ref HEAD }
    if ($branchName) {
        Write-Host -foregroundcolor darkyellow " $branchName" -nonewline
    }

    if ($ShowTiming) {
        Write-Host -foregroundcolor yellow " $lastcmdtime" -nonewline
    }
    elseif ($lastcmdtime.totalseconds -gt 3) {
        Write-Host -foregroundcolor yellow " $(format-timespan($lastcmdtime))" -nonewline
    }

    Write-Host
    if ($isElevated) {
        Write-Host -ForegroundColor White -backgroundcolor $waserror[0] -NoNewline "ADMIN"
    }
    Write-Host -foregroundcolor $waserror[0] -backgroundcolor $waserror[1] ([char]0xE0B0) -nonewline
    Write-Host -foregroundcolor $waserror[1] ([char]0xE0B0) -nonewline

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
Set-Alias tsvn Invoke-TortoiseSvn
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

function e { Invoke-Expression "$env:EDITOR $args" }
function spe { sudo procexp $args }
function rg { rg.exe --type-add xaml:*.xaml --type-add proj:*.*proj --type-add cshtml:*.cshtml --type-add cs:!*.generated.cs --type-add cs:include:cs,cshtml -SH $args }

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
