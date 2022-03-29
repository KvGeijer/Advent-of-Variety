## Day 2 - Excel

Part 1 was very easy, but in part 2 I had some major toubles trying to do it without VBA. Basically, for each variable in each row I wanted to try to divide the whole row by it and see where the integer divisions were. But for this I needed a row for each value (3D array). This felt hard in Excel and I did not just want to have 16 matrixes stacked as it would be horrendous. I wanted to try to use COUNTIF on {INT(row/val) == row/val} for each val. Creating the range and then doing COUNTIF worked, but not doing both in one cell. So I could not get away with a 2D matrix using this method.

Instead I just created a very simple VBA function to return the sum of all integer divisions of a row with one value. Then subtarcted 1 from each result (everything divides itself).

## Input

Here I did not use any input file, but had a sheet for the input in the workbook. Thus that input can just be changed to another to get the resut for that input.

## Impression of Excel

I was surprised ad how limiting Excel felt. No doubt this is in part due to me not knowing things, but still. For example handling the varying size of the input was rather hard (as I needed the same number of computation rows as input rows). 

Using Macros and VBA Excel becomes a completely different beast though. But I would not recommend doing these more problem solving tasks in Excel.
