%% Add Directory Tree to MATLAB Path

addpath(genpath('~/Repositories/WOGRSS'));
cd ~/Repositories/WOGRSS

%% Read in Spatial Data Files

hucCodeShapePath = './data/huc10.shp';
overlayShapePath = './data/caCounties.shp';
hucCodeShapeStruct = shaperead(hucCodeShapePath,'UseGeoCoords',true);
overlayShapeStruct = shaperead(overlayShapePath,'UseGeoCoords',true);

%% Select Study Site

[hucID, hucIndex] = getHucCodeFnc(hucCodeShapeStruct,overlayShapeStruct);

%% Generate Grid Mask

gridDensity = 1116.99;
[gridMask, geoRasterRef] = hucCode2GridMaskFnc(hucCodeShapeStruct,...
    hucIndex,gridDensity);

%% Plot Grid Mask

geoshow(gridMask,geoRasterRef);
