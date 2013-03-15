/*
* This is an example showing one of the possible application of the jtfl4processing library.
* It simulates the bus arrivals panel you can find at
* http://www.tfl.gov.uk/tfl/gettingaround/maps/buses/tfl-bus-map/text/stopinfo.aspx?s=183
* that displays the arrival information for the King's Cross Station Bus Stop.
*
* Author: Emanuele tenko Libralato
*
*/

import jtfl4processing.core.*;
import jtfl4processing.core.impl.bus.model.*;
import jtfl4processing.core.impl.bus.instant.*;
import java.util.*;

PFont f;

JTFLBusAPI api = new BusStopInstantAPI();      // Initialize APIs
List<BusStopPrediction> predictionList;        // The List that will store the predictions
Calendar currentTime = Calendar.getInstance(); // We'll use it to make some date operations

String stopId = "183";                         // The id of the King's Cross Station bus stop

void setup() {
  
  // Gets array of prediction for the bus stop
  // In this case I use a List to store the predictions but you can choose to use arrays too.
  predictionList = api.getBusStopPredictionList(stopId,"StopPointName","EstimatedTime","LineID","DestinationText");
  // Let's sort the list by arrival time.
  Collections.sort(predictionList);
  
  // We set up the window height based on the number of predictions
  int maxHeight = (predictionList.size()+2)*24;
  size(400,maxHeight);
  f = createFont("Courier",16,true);
  
}

void draw() {
 
  background(0);
  textFont(f,12);
  fill(255,198,0);
  text("Route",50,20);
  textAlign(CENTER);
  text("Destination",width/2,20);
  text("Time",350,20);
  
  // We iterate the list and we print out the values we need.
  for(int i=0; i< predictionList.size(); i++){
    // we retrieve the line id
    text(predictionList.get(i).getLineId(),50,20*(i+2));
    textAlign(CENTER);
    // the destination text
    text(predictionList.get(i).getDestinationText(),width/2,20*(i+2));
    // and we calculate how many minutes we still have to wait
    text(getMinutesOfWait(predictionList.get(i).getEstimatedTime()),350,20*(i+2));
  }
  
  // Clock.
  textAlign(CENTER);
  text(Calendar.HOUR_OF_DAY+":"+Calendar.MINUTE,width/2,height-20);
  
}

// The function gets a date expressed in Unix Time (http://en.wikipedia.org/wiki/Unix_epoch)
// and it returns the difference between that and the current time, expressed in minutes.
int getMinutesOfWait(Long timeOfArrival){
  return (int)((timeOfArrival-currentTime.getTimeInMillis())/1000/60);
}



