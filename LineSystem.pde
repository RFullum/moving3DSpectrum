class LineSystem
{
  ArrayList<SpectLine> spectLines;  // Lines in the system

  // Constructor
  LineSystem()
  {
    spectLines = new ArrayList<SpectLine>();
  }

  /*
  Add new line to the lineSystem. Pass the iterator to spectLine
  to track which spectrum in the spectrumList it's attached to the line
  */
  void addLine(SpectLine newLine)
  {
    spectLines.add( newLine );
  }
  
  // Runs all lines in spectLines
  void run()
  {
    for (SpectLine sL : spectLines)
    {
      sL.run();
    }
  }
  
  // Removes spectrum from spectLines when the line has gone beyond 3D box
  void killLines()
  {
    for (int i=0; i<spectrumList.size(); i++)
    {
      SpectLine sL = spectLines.get(i);
      if (sL.isDead())
      {
        spectLines.remove(i);
      }
    }
  }
}
