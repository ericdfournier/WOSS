function [ rasterMosaicBufferData ] = rasterMosaicDataBufferFnc( ...
                                            inputRasterMosaicData, ...
                                            bufferTypeVector, ...
                                            bufferBoundaryCell, ...
                                            gridMask, ...
                                            gridMaskGeoRasterRef )
%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x) ...
    x == 5);
addRequired(P,'nargout',@(x) ...
    x == 1);
addRequired(P,'inputRasterMosaicData',@(x) ...
    iscell(x) && ...
    all(all(~cellfun(@isempty,x))));
addRequired(P,'bufferTypeVector',@(x) ...
    isnumeric(x) && ...
    ~isempty(x));
addRequired(P,'bufferBoundaryCell',@(x) ...
    iscell(x) && ...
    any(~cellfun(@isempty,x)));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,inputRasterMosaicData,bufferTypeVector, ...
    bufferBoundaryCell,gridMask,gridMaskGeoRasterRef);

%% Function Parameters

rasterCount = size(inputRasterMosaicData,1);
rasterMosaicBufferData = cell(rasterCount,2);

%% Generate Output Raster Buffer Mosaic Dataset

for i = 1:rasterCount
    
    rasterMosaicBufferData{i,1} = rasterDataBufferFnc( ...
        inputRasterMosaicData{i,1}, ...
        bufferTypeVector(i,1), ...
        bufferBoundaryCell{i,:}, ...
        gridMask, ...
        gridMaskGeoRasterRef );
    rasterMosaicBufferData{i,2} = [inputRasterMosaicData{i,2},'Buffer'];

end

end