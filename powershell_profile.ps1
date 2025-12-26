# 1. Enable Emacs keybindings (C-a, C-e, etc.)
Set-PSReadLineOption -EditMode Emacs

# 2. Rebind Up/Down arrows for substring history search (your favorite part)
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

oh-my-posh init pwsh | Invoke-Expression
