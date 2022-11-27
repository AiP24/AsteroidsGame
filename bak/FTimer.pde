//staticish class used to track delays in the program, eg between asteroid spawns
class Timer {
  private double initial;
  private HashMap<String, Double> timers = new HashMap<String, Double>();
  public Timer() {
    initial = millis();
  }
  public void addTimer(String timerName, double delay) {
    timers.put(timerName, millis()+delay);
  }
  public boolean timerDone(String timerName) {
    //if the timer key doesn't exist, return true, eg to allow a shot timer
    return !timers.containsKey(timerName) || millis()>=timers.get(timerName);
  }
  public double getDiff(String timerName) {
    return timers.get(timerName)-millis();
  }
} 
