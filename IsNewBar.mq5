datetime LastTime; // Global var

/**
 * Open time of the last bar for the current symbol & period.
 *
 * @param string symbol_name
 * @param ENUM_TIMEFRAMES timeframe
 * @param ENUM_SERIES_INFO_INTEGER prop_id
 *
 * @return bool
 */
bool IsNewBar() {
  datetime CurrentTime = (datetime) SeriesInfoInteger(Symbol(), Period(), SERIES_LASTBAR_DATE);   
  if (CurrentTime == LastTime) {
    return false;
  } else {
    LastTime = CurrentTime;
    return true;
  }
}
