/*

	GridTrader v1.mqh
	Copyright 2022, Orchard Forex
	https://www.orchardforex.com

*/

#property copyright "Copyright 2022, Orchard Forex"
#property link      "https://www.orchardforex.com"
#property version   "1.00"
#property strict

#define FRAMEWORK_VERSION_3_01
#define FRAMEWORK_VERSION
#include <Orchard/Frameworks/Framework.mqh>

//
//	Inputs
//

//	V1 grid trading is simple, we just need spacing between trades
//		and lot sizes
input	int		InpLevelPoints			=	0;						//	Trade gap in points

//	Now some general trading info
input	double	InpOrderSize			=	0.00;					//	Order size
input	string	InpTradeComment		=	"Grid Trader V1";	//	Trade comment
input	int		InpMagic					=	222222;				//	Magic number

#include "Expert.mqh"
CExpert*	Expert;

int OnInit() {

	Expert	=	new CExpert(	InpLevelPoints,
										InpOrderSize, InpTradeComment, InpMagic);
	
   return(Expert.InitResult());

}

void OnDeinit(const int reason) {

	delete	Expert;
	        
}

void OnTick() {

	Expert.OnTick();
	return;
	
}

