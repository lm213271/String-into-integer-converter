#############################################################
# NOTE: this is the provided TEMPLATE as your required 
#	starting point of HW1 MIPS programming part.
#
# CS465-001 F2020 HW1  
#############################################################
#############################################################
# PUT YOUR TEAM INFO HERE
# NAME: Laila Mashel
# G# 01127216
# NAME 2
# G# 2
#############################################################

#############################################################
# DESCRIPTION OF ALGORITHMS 
#
# PUT YOUR ALGORITHM DESCRIPTION HERE
# 1. hexdecimal string to integer value
# # To convert hex to decimal we use this formula
# (dn-1*16^n-1)+...+(d1*16^1)+(d0*16^0)
# So the first thing I do is to check whether each digit of string is valid
# if the char is between 0-9 we subtract it from 48 to convert it and
# if it is between A - F we subtract it from 55 to comvert it
# otherwise if the digit is not valid I report error.
# then after checking I used the above formula to calculate it.
# 2. extract n bits from index start
# I take two input from user. INPUT2 is the start and INPUT3 is the n
# then I did 1 left shift n then subtract it from 1 and store it in register s1.
# then I add the start input with 1 and subtract it from n and store it in s0.
# then I and s0 and s1 to get the extracted bit.
#############################################################

#############################################################
# Data segment
# 
# Feel free to add more data items
#############################################################
.data
	INPUTMSG: .asciiz "Enter a hexadecimal number: "
	INPUTSTARTMSG: .asciiz "Where to start extraction (31-MSB, 0-LSB)? "
	INPUTNMSG: .asciiz "How many bits to extract? "
	OUTPUTMSG: .asciiz "Input: "
	BITSMSG: .asciiz "Extracted bits: "
	ERROR: .asciiz "Error: Input has invalid digits!"
	EQUALS: .asciiz " = "
	NEWLINE: .asciiz "\n"
	ZERO: .asciiz "0"
	TEN: .asciiz "A"
	
	.align 4
	INPUT: .space 8
	INPUT2: .space 8
	INPUT3: .space 8

#############################################################
# Code segment
#############################################################
.text

#############################################################
# Provided entry of program execution
# DO NOT MODIFY this part
#############################################################
		
main:
	li $v0, 4
	la $a0, INPUTMSG
	syscall	# print out MSG asking for a hexadecimal
	
	li $v0, 8
	la $a0, INPUT
	li $a1, 9 # one more than the number of allowed characters
	syscall # read in one string of 8 chars and store in INPUT

#############################################################
# END of provided code that you CANNOT modify 
#############################################################
				
	#li $v0, 4
	#la $a0, INPUT
	#syscall # print out string that read in 
	#li $v0, 4
	#la $a0, NEWLINE
	#syscall				
##############################################################
# Add your code here to calculate the numeric value from INPUT 
##############################################################
						
	la	$t0, ($a0)		# initializeing the address of inputMSG into t0 
	li	$s0, 0			# sum of digits = 0
	 j	check_char
check_char:
	lbu	$t1, 0($t0)		# load byte from input
	beq 	$t1, $zero, report_value# end of string return to report_value
	beq 	$t1, ' ', report_value	
	ble 	$t1, '9', int_convert	# if hex char is less than 9 go to int_convert
	bgt 	$t1, '9', error_check	# if hex char is greater than 9 go to error_check
					# to see if it's between A-F
	j	convert_hex
convert_hex:	
	addi	$t1, $t1, -55		# t1 -= 55
	j	calculation
	
calculation:			
	li	$t2, 16			# assigning t2 = 16
	mul	$s0, $s0, $t2		# s0 *= t2
	add	$s0, $s0, $t1		# s0 += t1
	mul	$t2, $t2, 16		# t2 *= 16
	addi	$t0, $t0, 1		# t0 += 1
	#add	$v0, $v0, $s0		#v0 += s0
	j	check_char
			
int_convert:
	blt  	$t1, '0', error		# if the char is less than '0' report error
	addi	$t1, $t1, -48		# if the char is greater than '0' subtract it
					# from 48 and then jump to calculation
	j	calculation
	
error:
	li	$v0, 4
	la	$a0, NEWLINE
	syscall 
	
	li 	$v0, 4
	la	$a0, ERROR
	syscall
	j	exit
	
error_check:
	blt 	$t1, 'A', error		# if the char is less than 'A' report error
	bgt  	$t1, 'F', error		# if the char is greater than 'F' report error
	j	convert_hex		# i fthe char is between A-F go to convert_hex
	
																			
report_value:
#############################################################
# Add your code here to print the numeric value
# Hint: syscall 34: print integer as hexadecimal
#	syscall 36: print integer as unsigned
#############################################################	 
	
	move	$s7, $s0		# storing our converted value in register s7
	
	li	$v0, 4
	la	$a0, NEWLINE		# new line
	syscall
	
	li 	$v0, 4
	la 	$a0, OUTPUTMSG		# print out input:
	syscall	
	
	move  	$v0, $s0		# print out the number in hex
	li 	$v0, 34
	la 	$a0, ($s0) 	
	syscall
	
	li 	$v0, 4			# print out =
	la 	$a0, EQUALS
	syscall
	
	move	$v0, $s0		# print out the number in integer
	li 	$v0, 1
	la 	$a0, ($s0)
	syscall
				
	li	$v0, 4			# new line
	la	$a0, NEWLINE
	syscall
	
	li 	$v0, 4
	la 	$a0, INPUTSTARTMSG
	syscall				# print out MSG asking for which byte to extract	
					
	li 	$v0, 8
	la 	$a0, INPUT2
	li 	$a1, 2 			
	syscall 			
	
	j	input_convert
input2:
	j	ask_for_input

ask_for_input:	
	move	$s6, $s0					
	li	$v0, 4			# new line
	la	$a0, NEWLINE
	syscall
	
	li 	$v0, 4
	la 	$a0, INPUTNMSG
	syscall				# print out MSG asking for which byte to extract
	
	li 	$v0, 8
	la 	$a0, INPUT3
	li 	$a1, 2		
	syscall 			
	
	j	input_convert2
input3:
	j	extraction
	  
#############################################################
# Add your code here to get two integers: start and n
#############################################################
report_extracted_val:
	
	li	$v0, 4			# new line
	la	$a0, NEWLINE
	syscall
	
	li 	$v0, 4			# print out Extracted bits:	
	la 	$a0, BITSMSG
	syscall	
	
	move  	$v0, $s0		# print out the bit in hex
	li 	$v0, 34
	la 	$a0, ($s0) 	
	syscall
	
	li 	$v0, 4			# print out =
	la 	$a0, EQUALS
	syscall
	
	move	$a0, $s0		# print out the extracted bits in decimal
	li 	$v0, 1
	la 	$a0, ($s0)
	syscall
		
	j	exit
			
#############################################################
# Add your code here to extract bits and print extracted value
#############################################################

# t0 = start
# t1 = n

extraction:
	move	$t0, $s6
	move	$t1, $s0
	
	#lbu	$t0, 0($t4)		# load t4 into t0
	#lbu	$t1, 0($t6)		# load t6 into t1
														
	li	$k0, 1			# k0 = 1
	sllv 	$s1, $k0, $t1		# s1 = 1 << t1
	subi 	$s1, $t0, 1		# s1 = s1 & (-1)
	
	addi	$s2, $t0, 1		# s2 = t0 + 1		
	sub 	$s2, $s2, $t1		# s2 -= t1
	srlv  	$s2, $s7, $s2		# s2 = s0 >> s2
					# s0 = converted input 91a2b
	
	and	$s0, $s1, $s2		# s0 = s1 + s2

	j	report_extracted_val
	
#############################################################
# Optional exit 
#############################################################
exit:
	li $v0, 10
	syscall

# Example input	
# H: 0x 0   1    2    3    4    5    6    A
# B: 0000 0001 0010 0011 0100 0101 0110 1010
#    31   27   23   19   15   11   7    3  0 (index)

#######################################################################################
# converting start index and number of byte inputs
input_convert:						
	la	$t0, ($a0)		# initializeing the address of inputMSG into t0 
	li	$s0, 0			# sum of digits = 0
	 j	check_char2
check_char2:
	lbu	$t1, 0($t0)		# load byte from input
	beq 	$t1, $zero, input2	# end of string return to report_value
	beq 	$t1, ' ', input2	
	ble 	$t1, '9', int_convert2	# if hex char is less than 9 go to int_convert
	bgt 	$t1, '9', error	# if hex char is greater than 9 go to error_check
					# to see if it's between A-F
calculation2:			
	li	$t2, 16			# assigning t2 = 16
	mul	$s0, $s0, $t2		# s0 *= t2
	add	$s0, $s0, $t1		# s0 += t1
	mul	$t2, $t2, 16		# t2 *= 16
	addi	$t0, $t0, 1		# t0 += 1
	#add	$v0, $v0, $s0		#v0 += s0
	j	check_char2
	
int_convert2:
	blt  	$t1, '0', error		# if the char is less than '0' report error
	addi	$t1, $t1, -48		# if the char is greater than '0' subtract it
					# from 48 and then jump to calculation
	j	calculation2
	
############################################################################################

input_convert2:						
	la	$t0, ($a0)		# initializeing the address of inputMSG into t0 
	li	$s0, 0			# sum of digits = 0
	 j	check_char3
check_char3:
	lbu	$t1, 0($t0)		# load byte from input
	beq 	$t1, $zero, input3	# end of string return to report_value
	beq 	$t1, ' ', input3	
	ble 	$t1, '9', int_convert3	# if hex char is less than 9 go to int_convert
	bgt 	$t1, '9', error	# if hex char is greater than 9 go to error_check
					# to see if it's between A-F
calculation3:			
	li	$t2, 16			# assigning t2 = 16
	mul	$s0, $s0, $t2		# s0 *= t2
	add	$s0, $s0, $t1		# s0 += t1
	mul	$t2, $t2, 16		# t2 *= 16
	addi	$t0, $t0, 1		# t0 += 1
	#add	$v0, $v0, $s0		#v0 += s0
	j	check_char3
			
int_convert3:
	blt  	$t1, '0', error		# if the char is less than '0' report error
	addi	$t1, $t1, -48		# if the char is greater than '0' subtract it
					# from 48 and then jump to calculation
	j	calculation3
	
