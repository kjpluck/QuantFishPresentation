void setup()
{
  size(1000,1000);
  loadData();
  frameRate(15);
  textSize(40);
}


//315.98 414.24
//-0.20 1.02

float co2Min = 315.98;
float co2Max = 414.24;

float tempMin = -0.2;
float tempMax = 1.02;

float lastX, lastY;

void draw()
{
  background(0);
  
  drawAxis();
  
  Integer maxYear = 1958 + frameCount;
  
  text(maxYear, 200, 200);
  
  color colourTo = color(204, 102, 0);
  color colourFrom = color(0, 102, 153);
    
  for(Integer year = 1959; year <= maxYear; year++)
  {
    String co2String = co2Data.get(year.toString());
    float co2Conc = float(co2String);
    float co2Normalised = (co2Conc - co2Min) / (co2Max - co2Min);
    
    String tempString = tempData.get(year.toString());
    float temp = float(tempString);
    float tempNormalised = (temp - tempMin) / (tempMax - tempMin);
    
    float x = 100 + 800 * co2Normalised;
    float y = height - (100 + tempNormalised * 800);
    
    
    if(year == 1959)
    {
      lastX = x;
      lastY = y;
      continue;
    }
    
    strokeWeight(5);
    stroke(lerpColor(colourFrom, colourTo, tempNormalised));
    
    line(lastX, lastY, x, y);
    
    lastX = x;
    lastY = y;
  }
  
  if(maxYear>=2020)
    noLoop();
}

StringDict co2Data = new StringDict();
StringDict tempData = new StringDict();

void loadData()
{
  String[] strings = loadStrings("co2_annmean_mlo.csv");
  
  for(String line : strings)
  {
    String[] data = line.split(",");
    
    String year = data[0];
    String co2Conc = data[1];
    
    co2Data.set(year, co2Conc);
  }
  
  
  strings = loadStrings("GLB.Ts+dSST.csv");
  
  for(String line : strings)
  {
    String[] data = line.split(",");
    
    String year = data[0];
    String temp = data[13];
    
    tempData.set(year, temp);
  }
  
  println(tempData.get("1974"));
  
}

void drawAxis()
{
  pushStyle();
    textSize(20);
    stroke(100);
    
    line(100, height-100, 900, height-100);
    
    for(float co2Conc = 320; co2Conc < 420; co2Conc+=10)
    {
      float co2Normalised = (co2Conc - co2Min) / (co2Max - co2Min);
      float x = 100 + co2Normalised * 800;
      text(int(co2Conc), x, height - 70);
    }
    
    textAlign(CENTER);
    text("CO₂ concentration (ppm)", 500, height - 45);
    
    
    
    line(100, height-100, 100, height-900);
    textAlign(RIGHT);
    for(float temp = -0.1; temp <= 1.0; temp+=0.1)
    {
      float tempNormalised = (temp - tempMin) / (tempMax - tempMin);
      float y = 100 + tempNormalised * 800;
      text(nf(temp, 0, 2), 90, height - y);
    }
    
    pushMatrix();
      translate(30,500);
      rotate(-HALF_PI);
      textAlign(CENTER);
      text("Global average temperature (°C)", 0,0);
    popMatrix();
    
  popStyle();
}
