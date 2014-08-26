%% Add Directory Tree to MATLAB Path

addpath(genpath('~/Repositories/WOGRSS'));
cd ~/Repositories/WOGRSS

%% Generate Input Parameter Object

run ./prm/californiaSample.m

%% Select Study Site

[p.hucId, p.hucIndex, p.gridMask, p.gridMaskGeoRasterRef ] = ...
    extractGridMaskFnc( ...
    p.hucCodeShapeStruct, ...
    p.overlayShapeStruct, ...
    p.gridDensity );

%% Generate Raster Mosaic Datasets

rawRasterMosaicData = extractRawRasterMosaicDataFnc( ...
    p.topLevelRasterDir, ...
    p.topLevelVectorDir, ...
    p.rasterNanFloors, ...
    p.gridDensity, ...
    p.attributeFieldCell, ...
    p.hucCodeShapeStruct, ...
    p.hucIndex, ...
    p.gridMask, ...
    p.gridMaskGeoRasterRef );

%% Visualize Combined Final Raster Mosaic Datasets

rasterMosaicDataPlot( ...
    rawRasterMosaicData, ...
    p.gridMask, ...
    p.gridMaskGeoRasterRef );

%% Load Raster Data

load ./rslt/hucIndex_612.mat
