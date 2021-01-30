//+------------------------------------------------------------------+
//|                                                      Counter.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

float LOT_SIZE = 0.10;
float CANDLE_SIZE = 0.004;
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
   float candleSize = Open[1]-Close[1];
   if(candleSize >= CANDLE_SIZE && Open[0] > Close[0]){
      Print("Previous candleSize ", candleSize, " SELL SL ", Bid+(candleSize/2), " TP ", Ask-(candleSize/2));
      OrderSend(Symbol(),OP_SELL, LOT_SIZE, Bid, 2, Bid+(candleSize/2),Ask-(candleSize/2));
   }
   else if (candleSize <= CANDLE_SIZE * (-1) && Open[0] < Close[0]) {
      Print("Previous candleSize ", candleSize, " Buy SL ", Ask+(candleSize/2), " TP ", Bid-(candleSize/2));
      OrderSend(Symbol(),OP_BUY,LOT_SIZE ,Ask,2,Ask+(candleSize/2),Bid-(candleSize/2));
   }
}
//+------------------------------------------------------------------+
