@powershell.exe "Get-ChildItem -Recurse -File | Where-Object { $_ | Get-Item -Stream Zone.Identifier -ErrorAction Ignore } | Remove-Item -Stream Zone.Identifier;"
