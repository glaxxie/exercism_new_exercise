# Barcode

-95 modules (binary)?
-84 for digits, L and R
Start Guard: 3 modules, bar-space-bar, odd parity
End Guard: 3 modules, bar-space-bar, even parity
Mid: 5 modules, space-bar-space-bar-space

(quiet zone) 9 modules before Start and after End


-95 digits long string of binary 0,1
-split into 15 sections
.Start (Left guard): 3digits
.Left side: 6 x 7 digits, to create 6 decimals
.Mid (Center guard): 5 digits
.Right side: 6 x 7 digits, to create 6 decimals
.End (right guard): 3digits


Left side: has odd number of 1, being with 0 and end with 1
0 - 0001101
1 - 0011001
2 - 0010011
3 - 0111101
4 - 0100011
5 - 0110001
6 - 0101111
7 - 0111011
8 - 0110111
9 - 0001011

Right side: has even number of 1, being with 1 and end with 0
0 - 1110010
1 - 1100110
2 - 1101100
3 - 1000010
4 - 1011100
5 - 1001110
6 - 1010000
7 - 1000100
8 - 1001000
9 - 1110100






Left side:
First digit is type of bar code:
0 - standard
2 - weighted items
3 - pharmacy
5 - coupons

next 5: manyfacturer code

Right: first 5 are product code

Last is modulo check character



### Modulo check
Total = Sum of odd digits x 3  + Sum of even digits
next highest of 10 = ceil(total / 10) * 10
next highest of 10 % total should = last digit on the right