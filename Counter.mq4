//+------------------------------------------------------------------+
//|                                                      Counter.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//Values for 4 hr EURUSD
float CANDLE_SIZE = 0.004;
float MAX_LOT_SIZE = 0.15;
float MIN_LOT_SIZE = 0.01;
double MA_TOLERANCE = 0.005;

float TP_FACTOR = 2;
int SL_FACTOR = 3;
int CHECK_FACTOR = 4;

//Values for 1 hr EURUSD
/*float CANDLE_SIZE = 0.002;
float MAX_LOT_SIZE = 0.1;
float MIN_LOT_SIZE = 0.01;
double MA_TOLERANCE = 0.002;

float TP_FACTOR = 2;
int SL_FACTOR = 4;
int CHECK_FACTOR = 10;*/

float BASE_LOT = MAX_LOT_SIZE * CANDLE_SIZE;

int SHORT_PERIOD = 12;
int LONG_PERIOD = 40;
double MA_TREND_UP = MA_TOLERANCE * (-1);
double MA_TREND_DOWN = MA_TOLERANCE;

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
void OnTick(){
   if (OrdersTotal() > 0){
      return;
   }
   if(currentTradeCandle != NULL && currentTradeCandle == Time[0]){
      return;
   }
   float candleSize = Open[1]-Close[1];
   double maShort=iMA(NULL,0,SHORT_PERIOD,0,MODE_SMA,PRICE_CLOSE,0);
   double maLong=iMA(NULL,0,LONG_PERIOD,0,MODE_SMA,PRICE_CLOSE,0);
   double maCheck = maShort - maLong;
   
   if(candleSize >= CANDLE_SIZE && Close[0]-Open[0] > candleSize/CHECK_FACTOR && maCheck >= MA_TREND_UP ){
      float lot = BASE_LOT / candleSize;
      if (lot > MAX_LOT_SIZE) {
         lot = MAX_LOT_SIZE;
      } else if (lot < MIN_LOT_SIZE) {
         lot = MIN_LOT_SIZE;
      }
      float stopLoss = Ask-(candleSize/SL_FACTOR);
      float takeProfit = Bid+(candleSize/TP_FACTOR);
      // Print("Previous candleSize ", candleSize, " Buy SL ", stopLoss, " TP ", takeProfit, " lot ", lot);
      OrderSend(Symbol(),OP_BUY,lot ,Ask,2,stopLoss, takeProfit);
      currentTradeCandle = Time[0];
   }
   else if (candleSize <= CANDLE_SIZE * (-1) && Close[0]-Open[0] < candleSize/CHECK_FACTOR && maCheck <= MA_TREND_DOWN) {
      float lot = BASE_LOT / candleSize * (-1);
      if (lot > MAX_LOT_SIZE) {
         lot = MAX_LOT_SIZE;
      } else if (lot < MIN_LOT_SIZE) {
         lot = MIN_LOT_SIZE;
      }
      float stopLoss =  Bid-(candleSize/SL_FACTOR);
      float takeProfit = Ask+(candleSize/TP_FACTOR);
      // Print("Previous candleSize ", candleSize, " SELL SL ", stopLoss, " TP ", takeProfit, " lot ", lot);
      OrderSend(Symbol(),OP_SELL, lot, Bid, 2, stopLoss , takeProfit);
      currentTradeCandle = Time[0];
   }
}
//+------------------------------------------------------------------+
