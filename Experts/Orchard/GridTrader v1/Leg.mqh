/*

	GridTrader v1
	Expert
	
	Copyright 2022, Orchard Forex
	https://www.orchardforex.com

*/

#include <Orchard/Frameworks/Framework.mqh>

class CLeg : public CLegBase {

private:

	double					mLevelSize;

	int						mCount;
	double					mEntry;
	double					mExit;
	
	void						CloseAll(double price);
	void						OpenTrade(double price);
	void						Recount();
	void						Loop();
	
public:

	CLeg(	double levelSize,
			ENUM_POSITION_TYPE legType,
			double orderSize, string tradeComment, long magic);
	
};

CLeg::CLeg(double levelSize,
			ENUM_POSITION_TYPE legType,
			double orderSize, string tradeComment, long magic)
			: CLegBase(legType, orderSize, tradeComment, magic) {

	mLevelSize		=	levelSize;

	Recount();

}

void	CLeg::Loop() {

	//	First process the closing rules
	//	On the first run there may be no trades but there is no harm
	if (mLegType==POSITION_TYPE_BUY && mLastTick.bid>=mExit)	{
		CloseAll(mLastTick.bid);
	} else
	if (mLegType==POSITION_TYPE_SELL && mLastTick.ask<=mExit)	{
		CloseAll(mLastTick.ask);
	}

	//	Finally the new trade entries
	if (mLegType==POSITION_TYPE_BUY) {
		if (mCount==0 || mLastTick.ask<=mEntry) {
			OpenTrade(mLastTick.ask);
		}	
	} else {
		if (mCount==0 || mLastTick.bid>=mEntry) {
			OpenTrade(mLastTick.bid);
		}	
	}

}

void	CLeg::CloseAll(double price) {

	for (int i=PositionInfo.Total()-1; i>=0; i--) {
		
		if (!PositionInfo.SelectByIndex(i)) continue;
		if (PositionInfo.Symbol()!=mSymbol || PositionInfo.Magic()!=mMagic || PositionInfo.PositionType()!=mLegType) continue;
		
		int	ticket	=	(int)PositionInfo.Ticket();
	
		if (PositionInfo.PositionType()==POSITION_TYPE_BUY && (price-mLevelSize)>=PositionInfo.PriceOpen()) {
			Trade.PositionClose(ticket);
			continue;
		}
		
		if (PositionInfo.PositionType()==POSITION_TYPE_SELL && (price+mLevelSize)<=PositionInfo.PriceOpen()) {
			Trade.PositionClose(ticket);
			continue;
		}

	}
	Recount();

}

void	CLeg::OpenTrade(double price) {

	Trade.PositionOpen(mSymbol, (ENUM_ORDER_TYPE)mLegType, mOrderSize, price, 0, 0, mTradeComment);
	Recount();

}


/*
 *	Recount()
 *
 *	Mainly for restarts
 *	Scans currently open trades and rebuilds the position
 */
void		CLeg::Recount() {

	mCount					=	0;
	mEntry					=	0;
	mExit						=	0;
	
	double	high			=	0;
	double	low			=	0;
	
	double	lead			=	0;
	double	trail			=	0;

	for (int i=PositionInfo.Total()-1; i>=0; i--) {
		
		if (!PositionInfo.SelectByIndex(i)) continue;
		
		if (PositionInfo.Symbol()!=mSymbol || PositionInfo.Magic()!=mMagic || PositionInfo.PositionType()!=mLegType) continue;

		mCount++;
		if (high==0 || PositionInfo.PriceOpen()>high)		high	=	PositionInfo.PriceOpen();
		if (low==0 || PositionInfo.PriceOpen()<low)		low	=	PositionInfo.PriceOpen();

	}

	if (mCount>0) {
		if (mLegType==POSITION_TYPE_BUY) {
			mEntry	=	low-mLevelSize;
			mExit		=	low+mLevelSize;
		} else {
			mEntry	=	high+mLevelSize;
			mExit		=	high-mLevelSize;
		}
	}

}


