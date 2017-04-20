## SUBMISSION BY SAURABH SETH -- HW 8 FOR EXTRA CREDIT 

1. All the grammar conditions are working as described by the assignment.
2. Exponentiation is right-associative i.e. 2**3**2 = 512 not 64.
3. list, clear, quit, exit, sqrt are all keywords.
4. Extra keywords have been added for extra credit part. Please note that these will not work as identifiers. Details below -->
	'cbrt' --> Computes the cube root of x.
	'sin'  --> Computes the sine of x (expressed in radians).
	'cos'  --> Computes the cosine of x (expressed in radians).
	'tan'  --> Computes the tangent of x (expressed in radians).
	'log'  --> Computes the logarithm of x.


******************* EXTRA CREDIT *************************

5. Meaningful message printed after assignment and clear statements for 1st point (very easy)
	- On success of assignment, a saved to memory message printed with value.
	- On success of clear, a removed from memory message printed with value.
	
6. Language has been extended for 2nd point (fairly easy) -->
	- Allowing Empty Lines (statements) in the input
	- Allowing Multiple Statements on an input line separated by semicolons. Please note that ";" is now a valid symbol.
	- Unary Minus Operator. This is done by including extra rules in grammar like -->
			
			factor ::= id  |  number  |  ( exp ) | sqrt ( exp ) | - number  |  - ( exp )
	- Please note that -id will not work. Instead use -(id) in the calculations.
			
7. Language has been extended for 3rd point (more complex) -->
	- 'cbrt' --> Computes the cube root of x.
	- 'sin'  --> Computes the sine of x (expressed in radians).
	- 'cos'  --> Computes the cosine of x (expressed in radians).
	- 'tan'  --> Computes the tangent of x (expressed in radians).
	- 'log'  --> Computes the logarithm of x.
	- Extended grammar rules -->
			
		factor ::= id  |  number  |  ( exp ) | sqrt ( exp ) | - number  |  - ( exp ) | cbrt ( exp ) | sin ( exp ) | cos ( exp ) | tan ( exp ) | log ( exp )


8. Add decent error handling for 4th point -->
	- This has been implemented in all over the code by producing meaningful error messages 
		- If exp is not evaluated, prints "INCORRECT SYNTAX. PLEASE CHECK THE MANUAL."
		- If extra characters are present, prints "JUNK PRESENT IN THE INPUT."
		- In clear statement, if identifier not present in the map, prints "UNKNOWN IDENTIFIER --> " id.
		- In assign statement, if exp not evaluated, prints "INCORRECT SYNTAX. PLEASE CHECK THE MANUAL."
		- If unassigned ID used anywhere in exp, prints "UNKNOWN IDENTIFIER --> id. INCORRECT SYNTAX. PLEASE CHECK THE MANUAL."
		- Check for Left Parenthesis for all expressions, prints "MISSING ( IN THE EXPRESSION."
		- Check for Right Parenthesis for all expressions, prints "MATCHING ) NOT FOUND FOR (."
		- Specific message for 0 division, prints "DIVISION BY ZERO NOT ALLOWED."
		- In clear statement, other symbol provided instead of identifier, print "ERROR IN SYNTAX. AN IDENTIFIER EXPECTED AFTER clear."
		
	- Resumes scanning and parsing after an error in an input statement.