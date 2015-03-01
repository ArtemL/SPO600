.text                                   //Starting up
.globl    _start                        //starting at _start
start = 1                               //lowest possible value for the factors
max = 13                                //maximum number + 1, used as a limit for the table
_start:
        mov     x19, start              //saving 1 in a register used for the second factor
        mov     x20, x19                //saving 1 in a register used for the first factor
        adr     x22, msg                //storing the address of our message
        mov     x27, ' '                //storing a space symbol to be used for cleaning
        b       iloop                   //starting the inner loop. Technically, separating the loops is not needed for the code, but it looks more organized
oloop:                                  //start of the outer loop
        strb    w27, [x22,0]            //clearing the first digit of the first factor
        strb    w27, [x22,10]           //clearing the first digit of the result
        strb    w27, [x22,11]           //clearing the second digit of the result
        add     x19, x19, 1             //incrementing the second factor
        udiv    x23, x19, x21           //saving the first digit of the new second factor
        msub    x24, x21, x23, x19      //saving the second digit of the new factor
        mov     x3, 5                   //saving the starting point of the second factor inside the string
        bl      format                  //calling the function to format the number
        adr     x1, spc                 //saving the address of the spacer
        mov     x2, lns                 //saving the length of the spacer
        bl      print                   //calling the print function
        cmp     x19, max                //comparing the second factor to the exit condition
        bne     iloop                   //if it's smaller, do the inner loo again
        mov     x0, 0                   //if not, put the exit codes in the appropriate registers
        mov     x8, 93
        svc     0                       //doing syscall
format:                                 //start of the format function. Initially I had the calculations of "udiv" and "msub" here as well, but it appeared to be a waste of space, since I had to save the values of my factor digits in the specific registers, so although the code was shorter, additional "mov" operations were added
        cmp     x23, 0                  //checking if the first digit is equal to zero
        beq     skip                    //if it is, don't do anything
        add     x23, x23, '0'           //if it's not, make a character out of it
        strb    w23, [x22,x3]           //and put in the specified place
skip:
        add     x24, x24, '0'           //make a character out of the second digit. Since the second digit is always present, I can't make it not show up, or a number, say, ten, would show up as "1 "
        add     x3, x3, 1               //increasing the location counter
        strb    w24, [x22,x3]           //changing the second digit
        br      x30                     //branching to the value of the register with the return value. Took me a while to figure this line out!
iloop:                                  //start of the inner loop
        mul     x25, x19, x20           //getting the multiplication result
        mov     x21, 100                //saving a divisor for hundreds in a register
        udiv    x23, x25, x21           //saving the first digit of the result
        msub    x26, x21, x23, x25      //saving the second two digits of the result
        mov     x21, 10                 //saving a divisor for tens in a register
        udiv    x24, x26, x21           //saving the second digit of the result
        mov     x3, 10                  //saving the starting point of the result inside the string
        bl      format                  //calling the function to format the first two digits of the result
        udiv    x23, x26, x21           //saving the second digit of the result in the first digit's register )for correct owrk of the format function.)
        msub    x24, x21, x23, x26      //saving the last digit of the result
        mov     x3, 11                  //saving the location of the second digit of the result inside the string
        bl      format                  //calling the function to format the last two digits of the result
        cmp     x25, 9                  //checking if the initial value was at least two digits
        bgt     zero                    //if it was, do nothing
        strb    w27, [x22,11]           //if it wasn't, wipe the second digit of the result, so it doesn't appear as, say, "01".
zero:
        adr     x1, msg                 //saving the address of the message
        mov     x2, len                 //saving the length of the message
        bl      print                   //calling the print function
        add     x20, x20, 1             //increasing the first factor
        udiv    x23, x20, x21           //saving the first digit of the new first factor
        msub    x24, x21, x23, x20      //saving the second digit of the new first factor
        mov     x3, 0                   //saving the starting point of the first factor
        bl      format                  //calling the function to format the first factor
        cmp     x20, max                //comparing the first factor to the exit condition
        bne     iloop                   //if it's smaller, do the inner loop again
        mov     x20, start              //if it's not, assign "1" to it
        mov     x24, 1                  //making the second digit register equal to 1 as well (otherwise it will keep the last value of the second digit, as the first line will start with "3", not "1")
        mov     x3, 0                   //saving the starting point of the first factor
        bl      format                  //calling the function to format the first factor. This extra call can't be avoided, since I am using the formnat function again for the second factor
        b       oloop                   //going back to the outer loop
print:                                  //start of the print function
        mov     x0, 1                   //moving the "write to the standard output" values to the appropriate registers
        mov     x8, 64
        svc     0                       //doing syscall
        br      x30                     //branching to the value of the return register
.data
        msg: .ascii  " 1 x  1 =   1\n"  //our message
        len = . - msg                   //the length of our message
        spc: .ascii  "-------------\n"  //our spacer
        lns = . - spc                   //the length of our spacer
