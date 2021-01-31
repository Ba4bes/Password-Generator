<#
    .SYNOPSIS
    This script generates a password
    .DESCRIPTION
    A password is generated that contains at least one  non-capital, one capital, one number and one special character.
    It will than removes the similar characters (like I & l)
    .PARAMETER length
    The length of the password
    .NOTES
    Written by Barbara Forbes
    @Ba4bes
    https://4bes.nl
    #>
param(
    [parameter(Mandatory = $true)]
    [int]$Length
)

#Unix-16 codes are used to create numbers for all the needed characters
$Charsets = @{
    special      = @( (35..38), (40..47), (58..64) , (91..96), (123..126))
    numbers      = 48..57
    capitals     = 65..90
    nonecapitals = 97..122
}

# An array is created, maximum length is set
$PasswordArray = @()
[int]$left = $charsets.Count
[int]$Count = 0
foreach ($Charset in $Charsets.GetEnumerator()) {
    $Left--

    # a random ammount of characters is chosen
    if ($left -gt 0) {
        $Count = 1..([int]($Length / 2) - $left ) | Get-Random
    }
    else {
        $Count = $Length
    }

    $PasswordArray += (($Charset.value | Get-Random -Count $Count | ForEach-Object { [char]$_ }))
    $Length = $Length - $Count
}
[string]$GeneratedPassword = -join ($PasswordArray | Get-Random -Count $PasswordArray.length)

# Replace characters that can be confused with each other and characters that give issues in scripts
$ReplacedCharacters = "[1IiLl\|Oo0\-_]+\&\|="

while ($GeneratedPassword -match $ReplacedCharacters) {
    $randomcharacter = [char]((65..90) + (97..122) | Get-Random -Count 1)
    $GeneratedPassword = $GeneratedPassword -replace $Matches[0], $randomcharacter
}

# Return password to workflow
echo "::set-output name=password::$GeneratedPassword"
