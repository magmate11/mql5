input int                 SlowMaPeriod = 100,
                          FastMaPeriod = 13,
                          SlowMaShift = 0,
                          FastMaShift = 0,
                          BarsBackToStart = 0;
input ENUM_MA_METHOD      SlowMaMethod = MODE_SMMA,
                          FastMaMethod = MODE_SMMA;
input ENUM_APPLIED_PRICE  SlowMaAppliedPrice = PRICE_MEDIAN,
                          FastMaAppliedPrice = PRICE_MEDIAN;
input bool                CopyAsSeries = true;
double                    SlowMaArray[],
                          FastMaArray[];
int                       SlowMaHandle,
                          FastMaHandle,
                          BarsToCount = 4;

//+------------------------------------------------------------------+

int OnInit() {
  SlowMaHandle = iMA(Symbol(), Period(), SlowMaPeriod, SlowMaShift, SlowMaMethod, SlowMaAppliedPrice);
  FastMaHandle = iMA(Symbol(), Period(), FastMaPeriod, FastMaShift, FastMaMethod, FastMaAppliedPrice);
  if (SlowMaHandle < 0 || FastMaHandle < 0) {
    Alert("MaHandle Creation Has Failed With Error : ", GetLastError());
    return(-1);
  }
  Print("GetSignal() : ", GetSignal());
  return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+

void OnDeinit(const int reason) {
  IndicatorRelease(SlowMaHandle);
  IndicatorRelease(FastMaHandle);
}

//+------------------------------------------------------------------+

int GetSignal() {
  ResetLastError();
  int tradesignal = -1;
  if (!(CopyMaBufferAsSeries(SlowMaHandle, 0, BarsBackToStart, BarsToCount, CopyAsSeries, SlowMaArray) && CopyMaBufferAsSeries(FastMaHandle, 0, BarsBackToStart, BarsToCount, CopyAsSeries, FastMaArray))) {
    Print("CopyMaBufferAsSeries Has Failed With Error : ", GetLastError());
    return(tradesignal);
  }
  // int digis = (int) SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
  // for (int i = 0; i < ArraySize(SlowMaArray); i++) Print("SlowMaArray ", i, " = ", DoubleToString(SlowMaArray[i], digis));
  // for (int i = 0; i < ArraySize(FastMaArray); i++) Print("FastMaArray ", i, " = ", DoubleToString(FastMaArray[i], digis));
  if (FastMaArray[1] > SlowMaArray[1]) {
    if (FastMaArray[2] <= SlowMaArray[2] && FastMaArray[3] <= SlowMaArray[3]) tradesignal = 0; // Cross Up
  } else if (FastMaArray[1] < SlowMaArray[1]) {
    if (FastMaArray[2] >= SlowMaArray[2] && FastMaArray[3] >= SlowMaArray[3]) tradesignal = 1; // Cross Down
  }
  return(tradesignal);
}

//+------------------------------------------------------------------+

bool CopyMaBufferAsSeries(int handle, int buffer, int start, int number, bool asSeries, double &M[]) {
  if (CopyBuffer(handle, buffer, start, number, M) <= 0) return(false);
  ArraySetAsSeries(M, asSeries);
  return(true);
}

//+------------------------------------------------------------------+
