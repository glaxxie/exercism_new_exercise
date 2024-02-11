# Instructions

Your task is to implement a barcode processor.

The Universal Product Code (UPC or UPC code) is a barcode symbology that is widely used worldwide for tracking trade items in stores.
There are many different types of UPC but for this exercise we would focus on the most well known standard : UPC-A.

A typical UPC-A represent a 12-digit number.
Each digit is represented by a unique pattern of 2 bars and 2 spaces, and the bars and spaces have variable width range from 1 to 4 modules wide. And each digit is represent by a 7 modules wide.

A complete UPC-A is 95 modules wide divided into sections:
- Start (`S`) : 3 modules wide 
- Left (`L`)  : 42 modules wide (6 digits * 7 modules wide each)
- Mid (`M`)   : 5 modiles wide
- Right (`R`) : 42 modules wide (6 digits * 7 modules wide each)
- End (`E`)   : 3 modules wise

To represent these barcode in a binary form to be process, the white module will be '0' and the black module will be '1'

These are the patterns and rules for those sections mentioned above:
- Start : Fixed '101' (black-white-black)
- Left  : Always start with '0' and end with '1'. Total width of all black bars ('1') is odd number of module (odd parity)
- Mid   : Fixed '01010' (white-black-white-black-white)
- Right : Always start with '1' and end with '0'. Total width of all black bars ('1') is even number of module (even parity)
- End   : Fixed '101' (black-white-black)

And these are the binary value for the digit being represent.

(Note: these are binary in the sense that they only use 1 and 0 to present them, however their value is not at all correlate to the actual binary system that we often use)


| Left digits | Right digits | Value |
| -------- | -------- | -------- |
| '0001101'| '1110010' | 0 |
| '0011001'| '1100110' | 1 |
| '0010011'| '1101100' | 2 |
| '0111101'| '1000010' | 3 |
| '0100011'| '1011100' | 4 |
| '0110001'| '1001110' | 5 |
| '0101111'| '1010000' | 6 |
| '0111011'| '1000100' | 7 |
| '0110111'| '1001000' | 8 |
| '0001011'| '1110100' | 9 |


An example:


| S   |    8    |    3   |  7    |  6    | 5     | 4     |  Mid  |  6    | 6     |  0    | 0     | 1     | 0     | E | Read  |
|-----|---------|--------|-------|-------|-------|-------|:-----:|-------|-------|-------|-------|-------|-------|---|-------|
| 101 | 0110111 | 0111101|0111011|0101111|0110001|0100011| 01010 |1010000|1010000|1110010|1110010|1100110|1110010|101| Normal|
| 101 | 0100111 | 0110011|0100111|0100111|0000101|0000101| 01010 |1100010|1000110|1111010|1101110|1011110|1110110|101| Upside|