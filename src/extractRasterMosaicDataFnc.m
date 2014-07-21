function [ rasterMosaicCell ] = extractRasterMosaicDataFnc( ...
                                                topLevelRasterDir, ...
                                                rasterNanFloor, ...
                                                gridMaskGeoRasterRef )
% extractRasterMosaicDataFnc.m Function to iteratively generate raster
% mosaic datasets for all raster data files within a set of sub-directories
% stored beneath a top level raster data storage directory. The raster
% mosaic files are generated with respect to the spatial extent of the grid
% mask data described in the input geo raster reference object
% gridMaskGeoRasterRef. 
%
% DESCRIPTION:
%
%   Function which generates an output cell array of raster mosaic datasets
%   for each raster dataset contained in the subdirectories of a top level
%   raster data storage directory. In each case the raster mosaic dataset
%   is created by stitching together disperate raster data files contained
%   within each subdirectory by querying the spatial extent metadata and
%   checking for any overlap with the spatial extent of the gridMask
%   dataset described by the input argument gridMaskGeoRasterRef.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ rasterMosaicCell ] =  extractRasterMosaicDataFnc( ...
%                                                   topLevelRasterDir, ...
%                                                   rasterNanFloor, ...
%                                                   gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   topLevelRasterDir = (1 x k) character array containing the text file
%                       names for the top level raster data directory
%                       containing a set of sub-directories storing all of
%                       the individual mosaic data files for each raster
%                       data category to be used in the analysis.
%
%   rasterNanFloor =    [j] scalar value indicating the floor of all real
%                       valued data elements in the input raster data sets.
%                       All values below this floor with automatically be 
%                       set to a value of NAN during the execution of the 
%                       routine. 
%
%   gridMaskGeoRasterRef = {q} cell orientated geo raster reference object
%                       providing spatial reference information for the
%                       input gridMask data layer
% 
% OUTPUTS:
%
%   rasterMosaicCell =  {r x 1} cell array in which each cell element 
%                       contains a raster dataset with the same spatial
%                       reference information as that contained in the 
%                       gridMaskGeoRasterRef but the values corresponding 
%                       to those contained within datafiles specified in
%                       the mosaicRasterList cell array
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
    x == 3);
addRequired(P,'nargout',@(x) ...
    x == 1);
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));
addRequired(P,'rasterNanFloor',@(x) ...
    isscalar(x) && ...
    ~isempty(x));
addRequired(P,'topLevelRasterDir',@(x) ...
    isdir(x) && ...
    ischar(x) && ...
    ~isempty(x));

parse(P,nargin,nargout,gridMaskGeoRasterRef,rasterNanFloor,...
    topLevelRasterDir);

%% Function Parameters

topLevelDirProps = dir(topLevelRasterDir);
subDirInd = logical(([topLevelDirProps.isdir] .* ~[topLevelDirProps.bytes])');
subDirInd(1:2) = 0;
subDirProps = topLevelDirProps(subDirInd);
subDirCount = sum(subDirInd);
subDirName = {subDirProps.name}';
rasterMosaicCell = cell(subDirCount,1);

%% Iteratively Generate Raster Mosaic Data for Each Sub Directory

for i = 1:subDirCount
    
    inputRasterDir = [topLevelRasterDir,'/',subDirName{i,1}];   
    rasterMosaicList = getRasterMosaicListFnc(inputRasterDir,...
        gridMaskGeoRasterRef);
    rasterMosaicCell{i,1} = rasterMosaicList2DataFnc(rasterMosaicList,...
        rasterNanFloor,gridMaskGeoRasterRef);

end

end