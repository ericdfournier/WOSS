%% Initialize Parameter Structure

p = struct;

%% Spatial Data Filepaths

p.hucCodeShapePath = ...
    '/Users/ericfournier/Repositories/WOGRSS/data/huc10.shp';
p.overlayShapePath = ...
    '/Users/ericfournier/Repositories/WOGRSS/data/caCounties.shp';

%% Create Spatial Data Structure Objects

p.hucCodeShapeStruct = shaperead(p.hucCodeShapePath,'UseGeoCoords',true);
p.overlayShapeStruct = shaperead(p.overlayShapePath,'UseGeoCoords',true);

%% Input Raster Data File Paths

p.inputRasterDirectory = ...
    '/Users/ericfournier/Desktop/raster';

%% Grid Mask Generation Parameters

p.gridDensity = 1116.99;