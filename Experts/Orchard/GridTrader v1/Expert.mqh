/*

	GridTrader v1
	Expert
	
	Copyright 2022, Orchard Forex
	https://www.orchardforex.com

*/

#include <Orchard/Frameworks/Framework.mqh>
#include "Leg.mqh"

class CExpert : public CExpertBase {

private:

	CLeg*						mBuyLeg;
	CLeg*						mSellLeg;

protected:

	double	mLevelSize;
	
	void		Loop();

public:

	CExpert(	int levelPoints,
				double orderSize, string tradeComment, long magic);
	~CExpert();

};


CExpert::CExpert(int levelPoints, double orderSize, string tradeComment, long magic)
						:	CExpertBase(orderSize, tradeComment, magic) {

	mLevelSize		=	PointsToDouble(levelPoints);

	mBuyLeg			=	new CLeg(mLevelSize, POSITION_TYPE_BUY, mOrderSize, mTradeComment, mMagic);
	mSellLeg			=	new CLeg(mLevelSize, POSITION_TYPE_SELL, mOrderSize, mTradeComment, mMagic);
	
	mInitResult		=	INIT_SUCCEEDED;
	
}

CExpert::~CExpert() {

	delete	mBuyLeg;
	delete	mSellLeg;
	
}

void		CExpert::Loop() {

	mBuyLeg.OnTick();
	mSellLeg.OnTick();
	
}
	
