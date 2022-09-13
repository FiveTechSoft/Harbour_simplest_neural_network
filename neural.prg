#define INPUT_SIZE 2
#define HIDDEN_SIZE 2
#define OUTPUT_SIZE 1

#define LEARNING_RATE 0.5

function Main()

	local aInput[ INPUT_SIZE ]
   local aHidden[ HIDDEN_SIZE ]
	local nOutput
   local aWih[ INPUT_SIZE ][ HIDDEN_SIZE ] // weights from input to hidden layer
   local aWho[ HIDDEN_SIZE ] // weights from hidden to output layer
   local aData := { { 0, 0, 0 }, { 0, 1, 1 }, { 1, 0, 1 }, { 1, 1, 0 } }  // Xor values
   local nError := 1, nAt, nDelta, nHDelta

   SET DECIMALS TO 9

	for n = 1 to INPUT_SIZE
		for m = 1 to HIDDEN_SIZE
			aWih[ n, m ] = hb_Random()
		next
	next		 

	for n = 1 to HIDDEN_SIZE
		aWho[ n ] = hb_Random()
	next	

	for n = 1 to 100000

		nAt = hb_RandomInt( 1, 4 )

		aInput[ 1 ] = aData[ nAt ][ 1 ]
		aInput[ 2 ] = aData[ nAt ][ 2 ]

		// feed forward
		for m = 1 to HIDDEN_SIZE
			aHidden[ m ] = 0
			for p = 1 to INPUT_SIZE
				aHidden[ m ] += aInput[ p ] * aWih[ p ][ m ]
			next	
			aHidden[ m ] = 1 / ( 1 + Math_E() ^ -aHidden[ m ] )
		next	

		nOutput = 0
		for m = 1 to HIDDEN_SIZE
			nOutput += aHidden[ m ] * aWho[ m ]
		next
		nOutput = 1 / ( 1 + Math_E() ^ -nOutput )

		// backpropagation
		nError = aData[ nAt ][ 3 ] - nOutput
		nDelta = nError * nOutput * ( 1 - nOutput )

		for m = 1 to HIDDEN_SIZE
			aWho[ m ] += LEARNING_RATE * aHidden[ m ] * nDelta
	   next		

		for m = 1 to HIDDEN_SIZE
			nHDelta = nDelta * aWho[ m ] * aHidden[ m ] * ( 1 - aHidden[ m ] ) 
			for p = 1 to INPUT_SIZE
				aWih[ p ][ m ] += LEARNING_RATE * aInput[ p ] * nHDelta
			next
		next		
   next

	for n = 1 to 4    // test
		aInput[ 1 ] = aData[ n ][ 1 ]
		aInput[ 2 ] = aData[ n ][ 2 ]

		for m = 1 to HIDDEN_SIZE
			aHidden[ m ] = 0
			for p = 1 to INPUT_SIZE
				aHidden[ m ] += aInput[ p ] * aWih[ p ][ m ]
			next	
			aHidden[ m ] = 1 / ( 1 + Math_E() ^ -aHidden[ m ] )
		next

		nOutput = 0
		for m = 1 to HIDDEN_SIZE
			nOutput += aHidden[ m ] * aWho[ m ]
		next	
		nOutput = 1 / ( 1 + Math_E() ^ -nOutput )

		? AllTrim( Str( aData[ n ][ 1 ] ) ), " XOR ", AllTrim( Str( aData[ n ][ 2 ] ) ), "=", nOutput
	next

return nil

#pragma BEGINDUMP

#include <hbapi.h>
#include <math.h>

#ifndef M_E 
   #define M_E  2.71828182845904523536
#endif   

HB_FUNC( MATH_E )
{
   hb_retnd( M_E );
}

#pragma ENDDUMP