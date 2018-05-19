# Coin Maker Scripts and Resources
Greetings!  These are in work scripts and resources to make your own fantasy coins with OpenSCAD and Python!  (Well, you don't really need the Python, but it sure helps with automating things.)

# The Process
## What you will need:
In order to use these files, you will need some things:
- Height Map images for your coin sides.  (See sample images for examples - grayscale is all you need.  Pure white will stand out the most, and pure black will be recessed the most.)
- A .csv file with how you want the coins constructed (will have the format a biit later in these instructions)

## Getting Started:
1. First, open OpenSCAD.  Adjust parameters as you need (such as the size of the coin and separation value.  
	* Make a test print of a coin if needed to confirm separation value
2. Next, gather all your height map images into the directory with the script
3. Add your height maps to the CSV file as appropriate
4. Open a python shell, and navigate to where the script and resources are.
5. Run the following python command:
`python BatchProcess.py sample.csv`
Where the 'sample.csv' is replaced by whatever your filename is.
6. Done!  You should have coins based on your image files!  (Rendering 'large' images, where the side is over 100 pixels wide, can take a while.)

# Errata
## CSV file format
The CSV is simply three columns, separated by commas:
Output coin STL name, Image file for side A of the coin, Image file for side B of the coin