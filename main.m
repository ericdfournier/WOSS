%% Add Directory Tree to MATLAB Path

addpath(genpath('~/Repositories/WOGRSS'));
cd ~/Repositories/WOGRSS

%% Generate Input Parameter Object

run ./prm/californiaSample.m

%% Select Study Site

[hucID, hucIndex] = getHucCodeFnc( ...
    p.hucCodeShapeStruct, ...
    p.overlayShapeStruct);

%% Generate Grid Mask

[gridMask, gridMaskGeoRasterRef] = hucCode2GridMaskFnc( ...
    p.hucCodeShapeStruct, ...
    hucIndex, ...
    p.gridDensity);

%% Extract Source Index

sourceIndex = getSourceIndexFnc( ...
    gridMaskGeoRasterRef, ...
    gridMask);

%% Generate Raster Mosaic List

rasterMosaicList = getRasterMosaicListFnc( ...
    p.inputRasterDirectory, ...
    gridMaskGeoRasterRef );

%% View Mosaic Extent

plotHandle = rasterMosaicExtentPlot( ...
    p.overlayShapeStruct, ...
    rasterMosaicList, ...
    gridMaskGeoRasterRef );

%% Generate Mosaic Dataset

