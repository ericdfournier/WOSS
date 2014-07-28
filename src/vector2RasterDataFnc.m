function [ outputRasterData ] = vector2RasterDataFnc( ...
                                                inputShapeStruct, ...
                                                attributeField, ...
                                                gridMask, ...
                                                gridMaskGeoRasterRef )
% vector2RasterDataFnc.m Function to convert an input vector dataset, in 
% the form of a shape struct array to a raster output using the raster
% spatial extent and data characteristics contained in the
% gridMaskGeoRasterRef input data object.
%
% DESCRIPTION:
%
%   Function to automatically convert a vector dataset to a raster version
%   that has the same characteristics of the input geoRasterReference
%   object corresponding to the gridMask. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputRasterData ] =  vector2RasterDataFnc(   inputShapeStruct, ...
%                                               attributeField, ...
%                                               gridMask, ...
%                                               gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   inputShapeStruct =  {j x 1} shapefile structure array containing the
%                       shapefile data to be converted to raster format
%
%   attributeField =    {char} character string corresponding to the
%                       attribute field of the inputShapeStruct that will
%                       be used to define the grid cell values in the
%                       output raster dataset
%
%   gridMask =          [n x m] binary input raster corresponding to the
%                       outline of the basin to be used as the spatial 
%                       reference for the rest of the analysis
%
%   gridMaskGeoRasterRef = {q} cell orientated geo raster reference object
%                       providing spatial reference information for the
%                       reference basin gridMask data layer
% 
% OUTPUTS:
%
%   outputRasterData =  [n x m] array that is a rasterized version of the
%                       inputShapeStruct spatial data layer where each grid
%                       cell's value corresponds to the value of the 
%                       desired attribute field at the point location of 
%                       that grid cell's centroid latitude and longitude
%                       coordinates
%
% EXAMPLES:
%   
%   Example 1 =
%
% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%                 University of California Santa Barbara               %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x) ...
    x == 4);
addRequired(P,'nargout',@(x) ...
    x == 1);
addRequired(P,'inputShapeStruct',@(x) ...
    isstruct(x) && ...
    ~isempty(x));
addRequired(P,'attributeField',@(x) ...
    ischar(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,inputShapeStruct,attributeField,gridMask, ...
    gridMaskGeoRasterRef);

%% Function Parameters

refMat = ones(size(gridMask));
[gridLat, gridLon] = findm(refMat,gridMaskGeoRasterRef);
featureCount = numel(inputShapeStruct);
outputRasterData = zeros(size(gridMask));
attributeVec = extractfield(inputShapeStruct,attributeField)';

%% Validate Attribute Field

if isnumeric(attributeVec) == 0
    
    error('Attribute Field Must Be Numeric');
    
end
    
%% Check Feature Containment

for i = 1:featureCount
    
    curPolyLat = [inputShapeStruct(i,1).Lat]';
    curPolyLon = [inputShapeStruct(i,1).Lon]';
    gridIntersect = inpolygon(gridLat,gridLon,curPolyLat,curPolyLon);
    gridIntersectMask = reshape(gridIntersect,size(gridMask));
    outputRasterData(logical(gridIntersectMask)) = attributeVec(i,1);
    
end

end