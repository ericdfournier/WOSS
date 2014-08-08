function [ outputRasterData ] = reclassifyRasterDataFnc( ...
													inputRasterData, ...
													rasterDataBreaks, ...
                                                    directionality, ...
													gridMask )
% reclassifyRasterDataFnc.m Functio to reclassify raster data into an
% ordinal scheme based upon a set of predefined break values. 
%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x) ...
	x == 4);
addRequired(P,'nargout',@(x) ...
 	x == 1);
	addRequired(P,'inputRasterData',@(x) ...
	isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'rasterDataBreaks',@(x) ...
    isnumeric(x) && ...
    size(x,2) == 1 && ...
    ~isempty(x));
addRequired(P,'directionality',@(x) ...
    ischar(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));

parse(P,nargin,nargout,inputRasterData,rasterDataBreaks,directionality, ...
    gridMask);

%% Function Parameters

breakCount = numel(rasterDataBreaks);
outputRasterData = zeros(size(gridMask));

%% Execute Reclassification Depending Upon Directionality Switch

if strcmp(directionality,'ascending') == 1;

    for i = 1:breakCount
        
        if i == 1
            
            currentBreakInd = ...
                inputRasterData <= rasterDataBreaks(i,1);
            outputRasterData(currentBreakInd) = 1;
            
        elseif i > 1 && i < breakCount
            
            currentBreakInd = ...
                inputRasterData <= rasterDataBreaks(i,1) & ...
                inputRasterData > rasterDataBreaks(i-1,1);
            outputRasterData(currentBreakInd) = i;

        else
            
            currentBreakInd = ...
                inputRasterData > rasterDataBreaks(i,1);
            outputRasterData(currentBreakInd) = breakCount+1;
            
        end
        
    end
    
    outputRasterData(gridMask == 0) = 0;
    
elseif strcmp(directionality,'descending') == 1;
    
    for i = 1:breakCount
        
        if i == 1
            
            currentBreakInd = ...
                inputRasterData <= rasterDataBreaks(i,1);
            outputRasterData(currentBreakInd) = breakCount+1;
            
        elseif i > 1 && i < breakCount
            
            currentBreakInd = ...
                inputRasterData <= rasterDataBreaks(i,1) & ...
                inputRasterData > rasterDataBreaks(i-1,1);
            outputRasterData(currentBreakInd) = breakCount-i;

        else
            
            currentBreakInd = ...
                inputRasterData > rasterDataBreaks(i,1);
            outputRasterData(currentBreakInd) = 1;
            
        end
        
    end
    
    outputRasterData(gridMask == 0) = 0;
    
elseif any(strcmp(directionality,{'ascending';'descending'})) == 0

    error('Directionality Input Character String Not Recognized');
    
end

end        