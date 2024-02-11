$leftBinaries = @{
    '0' = '0001101'
    '1' = '0011001'
    '2' = '0010011'
    '3' = '0111101'
    '4' = '0100011'
    '5' = '0110001'
    '6' = '0101111'
    '7' = '0111011'
    '8' = '0110111'
    '9' = '0001011'
}

$rightBinaries = @{
    '0' = '1110010'
    '1' = '1100110'
    '2' = '1101100'
    '3' = '1000010'
    '4' = '1011100'
    '5' = '1001110'
    '6' = '1010000'
    '7' = '1000100'
    '8' = '1001000'
    '9' = '1110100'
}


Function Invoke-UPCencoding() {
    <#
    .SYNOPSIS
    Encode a number into a UPC-A barcode pattern.

    .PARAMETER Number
    The 12-digit number to encode as a UPC-A barcode.

    .EXAMPLE
    Invoke-UPCencoding -Number "123456789012"
    Returns the UPC-A barcode pattern.
    #>
    [CmdletBinding()]
    param(
        [string]$Number
    )

    $start = $end = '101'
    $mid   = '01010'

    $left, $right =  $Number -split "(\d{6})" | Where-Object {$_}

    $leftEncoded  = -join ($left.ToCharArray()  | ForEach-Object {$leftBinaries[$_.ToString()]})
    $rightEncoded = -join ($right.ToCharArray() | ForEach-Object {$rightBinaries[$_.ToString()]})

    # need to implement a modulo check
    return "$start$leftEncoded$mid$rightEncoded$end"

}

Invoke-UPCencoding -Number 837654660010


