//+------------------------------------------------------------------+
//|                                                  TrendFollow.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

float CANDLE_SIZE = 0.004;

float MAX_LOT_SIZE = 0.15;
float MIN_LOT_SIZE = 0.01;
float BASE_LOT = MAX_LOT_SIZE * CANDLE_SIZE;

int TP_FACTOR = 2;
int SL_FACTOR = 3;
int CHECK_FACTOR = 4;

datetime currentTradeCandle;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   if (OrdersTotal() > 0){
      return;
   }
   if(currentTradeCandle != NULL && currentTradeCandle == Time[0]){
      return;
   }
   float candleSize = Close[1]-Open[1];
   if(candleSize >= CANDLE_SIZE && Close[0] > Open[0] ){
      float lot = BASE_LOT / candleSize;
      if (lot > MAX_LOT_SIZE) {
         lot = MAX_LOT_SIZE;
      } else if (lot < MIN_LOT_SIZE) {
         lot = MIN_LOT_SIZE;
      }
      float stopLoss = Ask-(candleSize/SL_FACTOR);
      float takeProfit = Bid+(candleSize/TP_FACTOR);
      Print("Previous candleSize ", candleSize, " Buy SL ", stopLoss, " TP ", takeProfit, " lot ", lot);
      OrderSend(Symbol(),OP_BUY,lot ,Ask,2,stopLoss, takeProfit);
      currentTradeCandle = Time[0];
   }
   else if (candleSize <= CANDLE_SIZE * (-1) && Close[0] < Open[0]) {
      float lot = BASE_LOT / candleSize * (-1);
      if (lot > MAX_LOT_SIZE) {
         lot = MAX_LOT_SIZE;
      } else if (lot < MIN_LOT_SIZE) {
         lot = MIN_LOT_SIZE;
      }
      float stopLoss =  Bid-(candleSize/SL_FACTOR);
      float takeProfit = Ask+(candleSize/TP_FACTOR);
      Print("Previous candleSize ", candleSize, " SELL SL ", stopLoss, " TP ", takeProfit, " lot ", lot);
      OrderSend(Symbol(),OP_SELL, lot, Bid, 2, stopLoss , takeProfit);
      currentTradeCandle = Time[0];
   }
   
}
//+------------------------------------------------------------------+
