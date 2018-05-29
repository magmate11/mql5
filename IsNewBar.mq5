datetime LastTime;

bool IsNewBar() {
  datetime CurrentTime = (datetime) SeriesInfoInteger(Symbol(), Period(), SERIES_LASTBAR_DATE);   
  if (CurrentTime == LastTime) {
    return false;
  } else {
    LastTime = CurrentTime;
    return true;
  }
}
