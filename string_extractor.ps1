# PowerShell String Extractor
# Extracts strings from binary files and constructs target strings from specific positions

function Get-BinaryStrings {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    
    try {
        $content = [System.IO.File]::ReadAllBytes($FilePath)
        $asciiString = [System.Text.Encoding]::ASCII.GetString($content)
        
        # PowerShell regex to match readable ASCII strings (3 or more characters)
        $pattern = '[ -~]{3,}'
        $strings = [regex]::Matches($asciiString, $pattern) | ForEach-Object { $_.Value }
        return $strings
    }
    catch [System.IO.FileNotFoundException] {
        Write-Host "File not found: $FilePath" -ForegroundColor Red
        return $null
    }
    catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
        return $null
    }
}

function Find-StringPositions {
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$Strings,
        [Parameter(Mandatory=$true)]
        [string]$TargetString
    )
    
    $positions = @()
    
    foreach ($char in $TargetString.ToCharArray()) {
        $found = $false
        
        for ($lineIdx = 0; $lineIdx -lt $Strings.Count; $lineIdx++) {
            $charIdx = $Strings[$lineIdx].IndexOf($char)
            if ($charIdx -ne -1) {
                $positions += @{
                    LineIndex = $lineIdx
                    CharIndex = $charIdx
                }
                $found = $true
                break
            }
        }
        
        if (-not $found) {
            Write-Host "Character '$char' not found in any string." -ForegroundColor Yellow
            return $null
        }
    }
    
    return $positions
}

function Build-Sentence {
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$Strings,
        [Parameter(Mandatory=$true)]
        [object[]]$Positions
    )
    
    $sentence = @()
    
    foreach ($pos in $Positions) {
        try {
            $line = $Strings[$pos.LineIndex]
            $char = $line[$pos.CharIndex]
            $sentence += $char
        }
        catch {
            Write-Host "Error: Position ($($pos.LineIndex), $($pos.CharIndex)) is out of range." -ForegroundColor Red
        }
    }
    
    return -join $sentence
}

function Generate-PowerShellCommand {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath,
        [Parameter(Mandatory=$true)]
        [object[]]$Positions
    )
    
    # Create the string array for positions
    $positionStrings = @()
    foreach ($pos in $Positions) {
        $positionStrings += "`$strings[$($pos.LineIndex)][$($pos.CharIndex)]"
    }
    
    # Build the command
    $command = @"
`$path = (Get-ChildItem env:PATH).Value.Split(';') | Where-Object { `$_ -like '*m32' } | Select-Object -First 1;
`$filePath = Join-Path `$path '$((Get-Item $FilePath).Name)';
`$content = [System.IO.File]::ReadAllBytes(`$filePath);
`$asciiString = [System.Text.Encoding]::ASCII.GetString(`$content);
`$strings = [regex]::Matches(`$asciiString, '[ -~]{3,}') | ForEach-Object { `$_.Value };
`$result = -join ($($positionStrings -join ','));
Invoke-Expression `$result
"@
    
    return $command
}

function Main {
    $filePath = "C:\Windows\System32\calc.exe"
    $targetString = Read-Host "Enter the string to construct"
    $targetString = $targetString.Trim()
    
    Write-Host "Loading file: $filePath" -ForegroundColor Cyan
    
    # Extract strings
    $strings = Get-BinaryStrings -FilePath $filePath
    
    if ($strings) {
        Write-Host "Found $($strings.Count) strings in the file." -ForegroundColor Green
        
        # Find positions for each character in the target string
        $positions = Find-StringPositions -Strings $strings -TargetString $targetString
        
        if ($positions) {
            Write-Host "Character positions:" -ForegroundColor Cyan
            $positions | Format-Table
            
            # Build the sentence using the found positions
            $sentence = Build-Sentence -Strings $strings -Positions $positions
            Write-Host "Extracted sentence: $sentence" -ForegroundColor Green
            
            # Generate PowerShell command
            $command = Generate-PowerShellCommand -FilePath $filePath -Positions $positions
            Write-Host "Run this command:" -ForegroundColor Cyan
            Write-Host $command -ForegroundColor Yellow
        }
        else {
            Write-Host "Failed to locate all characters in the target string." -ForegroundColor Red
        }
    }
    else {
        Write-Host "No readable strings found." -ForegroundColor Red
    }
}

# Run the script
Main
