Project
Variant 2
Author: Nastya Dernova
Language of project: Assembly language
Execution Environment: VS Code
Task Description:
Read N decimal numbers from stdin, separated by space or newline until EOF appears (maximum length of a line is 255 characters), with a maximum of 10,000 numbers.
Lines are separated by EITHER a sequence of bytes 0x0D and 0x0A (CR LF), or by one character - 0x0D or 0x0A.
Each number is an integer decimal signed number that needs to be converted to binary representation (word in two's complement).
Negative numbers start with '-'.

Note: if a number is too large in absolute value for a 16-bit signed representation, it should be represented as the maximum possible value (in absolute value).
Sort the binary values using the bubble sort algorithm (asc). If merge sort is used, there will be an additional bonus point.
Compute the median value and output it as a decimal to the console as a string (stdout).
Compute the average value and output it as a decimal to the console as a string (stdout).

Example:
2 10 0
Result:
2
