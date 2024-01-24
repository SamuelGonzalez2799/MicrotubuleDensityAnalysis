# MicrotubuleDensityAnalysis
## About the project
The goal of this script is to analyze the max intensity projections of the microtubule density within cells. The input for the code are max intensity projections in RGB of labelled microtubules within cells (the code assumes the microtubules are in the green channel, so this should be adjusted via imageJ before loading into the code). 


### Built With
MATLAB by Mathworks

## Getting Started

To use the code, download the script into the folder with your images to analyze. Of note, the script assumes that the images have been pre-processed. For processing, make sure that a maximum intensity projection of only the microtubule density within cells is performed. Then, make sure that the color is associated with the green channel (whether or not the fluorophore is actually green). Finally, make the image RGB. Lastly, ensure that all images have a similar name (ie. stacks0001, stacks 0002, etc) so that the code can more easily read in the seperate images. Finally, within the script, there are two parameters that may need to be changed: mt_threshold and cell_threshold. Ideally, these will be the same for all images in one set and across conditions. Sometimes, however, the performance (as measured by eye) can be poor and will require changing one or both of these parameters for different sets of cells. At the end of the day, the goal is to have the output look as close to the MT network seen with the input. 

## Prerequisites

Ensure Matlab is operational on your device. 

## Installation

This script requires some add-ons including: 
- Image Processing Toolbox


## Usage

Use the sample images along with the code to try it in your own system. To improve the quality of the analysis, try adjusting mt_threshold and cell_threshold until the code appears to be behaving for your images. Of note, due to the nature of this time of band-pass filtering, the analysis will never be perfect. Instead, however, the goal is to have it look decent and be consistent across images. The output of this script will be an excel file that tracks the mt-threshold and cell-threshold for each image as well as the total MT lenght, median MT lenght, mean MT length, std dev of the MT length and the MT density (which is the useful output for analysis; it gives the fraction of the cell area covered by the Microtubules). 

Of note, this code was used for some publications from the Gardner lab including: 

https://www.biorxiv.org/content/10.1101/2022.06.07.495114v1.abstract 

## Contributing

We welcome contributions to the code and we will try to make adjustment/suggestions in a timely manner.

If you have suggestions to improve the code, please fork the repository and create a pull request: 

1. Fork the project
2. Create your Feature Branch
3. Commit your Change
4. Push to the Branch
5. Open a pull request


## Contact

Samuel Gonzalez-(https://www.linkedin.com/in/samuel-gonzalez-081504163/) - samueljgonzalez@hotmail.com


