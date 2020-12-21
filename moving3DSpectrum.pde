/*
*  Classic 3D animated spectrum analyzer.
*  Each line shows the amplitude of FFT bands through height offset.
*  Colors also change from low to high frequencies, and again from low
*  to high amplitude. 
*  Camera flies to random positions, alwyas looking at center of 3D field.
*  
*  Robert Fullum Dec 2020
*/
import processing.sound.*;

// Audio Members
AudioIn audioIn;
FFT     fft;

// Use fftResolution to change fft bands. It's the exponent of 2 2^fftResolution 
int fftResolution     = 6;                           // Edit this
int bands             = (int)pow(2, fftResolution);
int halfBands         = bands / 2;
float smoothingFactor = 0.1f;                        // Higher = slower
float[] spectrum      = new float[bands];

ArrayList<float[]> spectrumList;                     // array of spectrum arrays

// Visualizer Members
LineSystem lineSystem;
int lineDrawSpeed = 60;  // Edit for more or less line drawings, higher is lines less often: frameCount % lineDrawSpeed == 0

// Camera motion
PVector camPos;
PVector nextPos;
float   camSpeed;

float centerX;
float centerY;
float centerZ;

float upX = 0.0f;
float upY = 1.0f;
float upZ = 0.0f;

float xBound;
float yBound;
float zBound; 

float minDistance = 20.0f;


void setup()
{
  fullScreen(P3D);

  // Audio setup
  audioIn = new AudioIn(this, 0);
  audioIn.start();

  fft = new FFT(this);
  fft.input(audioIn);

  spectrumList = new ArrayList<float[]>();


  // Visual setup
  lineSystem = new LineSystem();
  
  // Camera setup
  centerX = width / 2.0f;
  centerY = height / 2.0f;
  centerZ = 0.0f;

  upX = 0.0f;
  upY = 1.0f;
  upZ = 0.0f;

  xBound = width * 2.0f;
  yBound = height * 2.0f;
  zBound = height * 2.0f; 
  
  camPos  = new PVector ( random(-xBound, xBound), 
                          random(-yBound, yBound), 
                          random(-zBound, zBound) / tan(PI*30.0f / 180.0f) );
  nextPos = new PVector ( random(-xBound, xBound), 
                          random(-yBound, yBound), 
                          random(-zBound, zBound) / tan(PI*30.0f / 180.0f) );
  setCamSpeed();
}




void draw()
{
  background(0);

  //
  // Audio
  //
  fft.analyze();

  for (int i=0; i<bands; i++)
  {
    spectrum[i] += (fft.spectrum[i] - spectrum[i] * smoothingFactor);
  }

  if (frameCount % lineDrawSpeed == 0)
  {
    spectrumList.add(spectrum);
  }


  //
  // Visuals
  //

  // Add line for each spectrum stored
  for (int i=0; i<spectrumList.size(); i++)
  {
    lineSystem.addLine( new SpectLine(i, -height) );
  }

  // Moves lines in system, kills any that have gone offscreen
  lineSystem.run();
  lineSystem.killLines();
  
  /*  
  // Box drawn as a visual reference to test & see the center of 3D space
  
  pushMatrix();
    fill(255.0f, 247.0f, 0.0f);
    translate(width / 2.0f, height, 0.0f);
    box(20.0f, 20.0f, 20.0f);
  popMatrix();
  */
  
  // Moves camera around space
  cameraMotion();
}

// Moves camera to nextPos, sets a new nextPos and camSpeed, rinse, repeat
void cameraMotion()
{
  // When the camera is extremely close to the target position, set new camSpeed and new nextPos
  if (PVector.dist(camPos, nextPos) < minDistance)
  {
    nextPos = new PVector ( random(-xBound, xBound), 
                            random(-yBound, yBound), 
                            random(-zBound, zBound) / tan(PI*30.0f / 180.0f) );
    setCamSpeed();
  }
  
  // find the direction to the nextPos and multiply by camSpeed
  PVector direction = PVector.sub(nextPos, camPos);
  direction.normalize();
  direction.mult(camSpeed);
  
  // Get new camPos vector
  camPos.add(direction);

  camera(camPos.x, camPos.y, camPos.z, 
         centerX, centerY, centerZ, 
         upX, upY, upZ);
}


void setCamSpeed()
{
  camSpeed = random(5.0f, minDistance);
}
