$leftBinaries = @{
    '0001101' = 0
    '0011001' = 1
    '0010011' = 2
    '0111101' = 3
    '0100011' = 4
    '0110001' = 5
    '0101111' = 6
    '0111011' = 7
    '0110111' = 8
    '0001011' = 9
}

$rightBinaries = @{
    '1110010' = 0 
    '1100110' = 1 
    '1101100' = 2 
    '1000010' = 3 
    '1011100' = 4 
    '1001110' = 5 
    '1010000' = 6 
    '1000100' = 7 
    '1001000' = 8 
    '1110100' = 9 
}

Function Invoke-UPCdecoding() {
    <#
    .SYNOPSIS
    Decode a barcode.

    .DESCRIPTION

    .PARAMETER Barcode
    The 95-digits binary to decode into normal number and values.

    .EXAMPLE
    $barcode = '10100100110111101010001101100010100011011110101010101000010011101000100110110010111001001110101'
    Invoke-UPCdecoding -Barcode $barcode
    Return: 234543657245
    #>
    [CmdletBinding()]
    param(
        [string]$Barcode
    )
    
    $pattern = Get-PatternRegex

    if ($Barcode -match $pattern) {
        $left   = $Matches[1] -split "(\d{7})" | Where-Object {$_}
        $right  = $Matches[2] -split "(\d{7})" | Where-Object {$_}
    }else {
        Throw "The barcode is invalid"
    }

    $reverse = IsUpsideDown $left $right

    if ($reverse) {
        $left, $right = $right, $left
        [array]::Reverse($left)
        [array]::Reverse($right)
    }

    $leftDecode = $left | ForEach-Object {
        $key = $reverse ? -join ($_[($_.Length-1)..0]) : $_
        $leftBinaries[$key]
    }

    $rightDecode = $right | ForEach-Object {
        $key = $reverse ? -join ($_[($_.Length-1)..0]) : $_
        $rightBinaries[$key]
    }

    $full = $leftDecode + $rightDecode

    if (-not (ModuloCheck $full)) {
        Throw "Invalid barcode, failed modulo check"
    }

    -join $full
}

Function Get-PatternRegex() {
    <#
    .DESCRIPTION
    Helper function to generate the regex pattern for a proper frame of a barcode
    #>
    $rear       = "101"
    $mid        = "01010"
    $leftDigit  = "(?:0[01]{5}1)"
    $rightDigit = "(?:1[01]{5}0)"

    "$rear($leftDigit{6})$mid($rightDigit{6})$rear"
}

Function ModuloCheck() {
    <#
    .DESCRIPTION
    Helper function to do modulo check and valid the barcode
    #>
    param (
        [int[]]$Digits
    )
    $checkDigit = $Digits[-1]
    $sum = 0
    foreach ($i in 0..10) {
        $factor = $i % 2 ? 1 : 3
        $sum += $Digits[$i] * $factor
    }

    $roundedup = [math]::Ceiling($sum/ 10) * 10
    $roundedup % $sum -eq $checkDigit
}

Function IsUpsideDown() {
    <#
    .DESCRIPTION
    Helper function check if the barcode is being read upside down or not.
    Also it test for valid formatting
    #>
    param(
        [string[]]$LeftSide,
        [string[]]$RightSide
    )
    $UpsideDown = $false

    #these two loops right here go through the left and right side, count and check if the number of '1' is odd (1) or even (0)
    #if a side is in the correct format, it should be all odd or all even, so the unique value should be either 1 or 0
    $OneDigitOnLeft  = $LeftSide  | ForEach-Object {$_.Split('0').Count % 2} | Get-Unique
    $OneDigitOnRight = $RightSide | ForEach-Object {$_.Split('0').Count % 2} | Get-Unique

    # if there are not one unique value on either side, barcode is not legit
    if ($OneDigitOnLeft -is [array]) {
        Throw "Left side of the bar code should have odd number of 1."
    }
    if ($OneDigitOnRight -is [array]) {
        Throw "Right side of the bar code should have odd number of 0."
    }
    # then we just determine : if left is odd and right even, we read it normal. if it is reverse then we read it upside down
    if (-not $OneDigitOnLeft -and $OneDigitOnRight) {
        $UpsideDown = $true
    }
    $UpsideDown
}

#Etra info and example

#╭---------------------------------╮
#|   LeftSide  |  RightSide  | Val |
#|  '0001101'  |  '1110010'  |  0  |
#|  '0011001'  |  '1100110'  |  1  |
#|  '0010011'  |  '1101100'  |  2  |
#|  '0111101'  |  '1000010'  |  3  |
#|  '0100011'  |  '1011100'  |  4  |
#|  '0110001'  |  '1001110'  |  5  |
#|  '0101111'  |  '1010000'  |  6  |
#|  '0111011'  |  '1000100'  |  7  |
#|  '0110111'  |  '1001000'  |  8  |
#|  '0001011'  |  '1110100'  |  9  |
#╰---------------------------------╯

# __________________________________________________________________________________________________________________________
# Str|   8   |   3   |   7   |   6   |   5   |   4   | Mid |   6   |   6   |   0   |   0   |   1   |   0   |End|__Reading__| 
# 101|0110111|0111101|0111011|0101111|0110001|0100011|01010|1010000|1010000|1110010|1110010|1100110|1110010|101| Normal    | 
# 101|0100111|0110011|0100111|0100111|0000101|0000101|01010|1100010|1000110|1111010|1101110|1011110|1110110|101| Upsidedown|
# --------------------------------------------------------------------------------------------------------------------------


$barcode = '10101101110111101011101101011110110001010001101010101000010100001110010111001011001101110010101'
$upsideDown = -join $barcode[($barcode.Length-1)..0]
# expect 837654660010
Invoke-UPCdecoding -Barcode $barcode
Invoke-UPCdecoding -Barcode $upsideDown
