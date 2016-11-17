function [assets, assetLocations] = vsaListAssets(assetType, varargin)
%% What assets are available for a given type?
%
% [assets, assetLocations] = vsaListAssets(assetType) returns a cell array
% of assets of the given assetType that are available at the default
% locations.  Also returns a cell array of locations, one for each asset.
%
% vsaListAssets( ... 'locations', locations) specify a cell array of
% locations where to try to list assets, in the given order.  The default
% is taken from getpref('VirtualScenesAssets').
%
% vsaListAssets( ... 'vsaPrefs', vsaPrefs) specify an explicit
% preferences struct to use, instead of getpref('VirtualScenesAssets').
%
% 2016 RenderToolbox team

parser = MipInputParser();
parser.addRequired('assetType', @ischar);
parser.addParameter('locations', {}, @iscellstr);
parser.addAllPreferences('vsaPrefs', 'VirtualScenesAssets', []);
parser.parseMagically('caller');

if isempty(locations)
    locations = {vsaPrefs.locations.name};
end


%% List types from each location.
nLocations = numel(locations);
locationResults = cell(1, nLocations);
locationNames = cell(1, nLocations);
for ll = 1:nLocations
    strategy = vsaChooseStrategy(locations{ll}, 'vsaPrefs', vsaPrefs);
    if isempty(strategy)
        continue;
    end
    
    locationResults{ll} = strategy.list('assetType', assetType);
    locationNames{ll} = repmat(locations(ll), size(locationResults{ll}));
end

assets = cat(2, locationResults{:});
assetLocations = cat(2, locationNames{:});
