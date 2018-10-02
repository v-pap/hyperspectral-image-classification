# Hyperspectral Image (HSI) Classification
The purpose of this project is to classify the pixels of a hyperspectral image to specific categories. These images can be represented as 3D arrays where the first two dimensions represent the coordinates of the pixel and the 3rd dimension represents the different spectral bands, known as the spectral signature of the pixel.

### About the Classification
The classification to the 5 categories is done by three different classifiers (supervised):
1) Naive Bayes classifier
2) minimum Euclidean distance classifier
3) k-nearest neighbor classifier

## Getting Started

### Prerequisites

The only thing required is having a MATLAB enviroment installed.

### Installing

Get a copy of the project
```
git clone https://github.com/v-pap/hyperspectral_image_classification.git
```
## Using the program

In order to use the program you will have to open the MATLAB suite and browse the directory with the contents of the project.
Then in the src directory you will have to run the ```project_m_file.m``` file. 


## About the dataset
The dataset was provided by the pattern recognition / machine learning class of the [informatics and telecommunications department of the UoA](http://www.di.uoa.gr/eng) and it represents one area of the Salinas Valley located in California. The hyperspectral image has a resolution of 150x150 pixels with 204 spectral bands (from 0.2μm to 2.4μm) and a spatial resolution of 3.7 meters.

## License

This project is licensed under the MIT License

