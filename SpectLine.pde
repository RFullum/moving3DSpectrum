class SpectLine
{
  PShape spectLine;
  
  float zPos;
  float velocity;
  
  int spectrumListIndex;
  
  
  /*
  Constructor: Pass iteration to track the index of the line with
  its corresponding spectrumList index. X, y
  */
  SpectLine(int index, float z)
  {
    velocity = 10.0f;
    zPos = z;
    
    spectrumListIndex = index;
    createBands();
  }
  
  
  /*
  Creates a shape: a line made of vertexes using the spectrum values
  as height multipliers from the corresponding index in spectrumList.
  lerps color across spectrum using index.
  lerps color of each vertex across amplitude using height
  */
  void createBands()
  {
    spectLine = createShape();
    
    spectLine.beginShape();
    spectLine.noFill();
    spectLine.stroke(255);
    
    for (int i=0; i<bands; i++)
    {
      float xVert = width * ( i / (float)bands );
      float yVert = -height * spectrumList.get(spectrumListIndex)[i] * 0.5f;
      float zVert = 0.0f;
      
      color bass = color( map(yVert, 0.0f, -height * 0.5f, 3.0f, 255.0f),
                          map(yVert, 0.0f, -height * 0.5f, 0.0f, 62.0f),
                          map(yVert, 0.0f, -height * 0.5f, 255.0f, 62.0f) );
      color treble = color( map(yVert, 0.0f, -height * 0.5f, 0.0f, 255.0f),
                            map(yVert, 0.0f, -height * 0.5f, 249.0f, 94.0f),
                            map(yVert, 0.0f, -height * 0.5f, 255.0f, 9.0f) );
      
      spectLine.stroke( lerpColor( bass, treble, map(i, 0.0f, bands, 0.0f, 1.0f) ) );
      spectLine.vertex( xVert, yVert, zVert );
    }
    
    spectLine.endShape();
  }
  
  void run()
  {
    zPos += velocity;
    
    pushMatrix();
      translate(0.0f, height, zPos);
      shape(spectLine);
    popMatrix();
    
  }
  
  // If line has moved beyond the z axis, mark it as dead
  boolean isDead()
  {
    if (zPos > height)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
 
} 
