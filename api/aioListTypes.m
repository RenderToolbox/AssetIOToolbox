function [types, typeLocations] = aioListTypes(varargin)
%% What types of asset are available?
%
% [types, typeLocations] = aioListTypes() returns a cell array of asset
% types available at the default locations, and a cell arrays of locations,
% one for each type.
%
% aioListTypes( ... 'locations', locations) specify a cell array of
% locations where to try to list asset types, in the given order.  The
% default is taken from getpref('VirtualScenesAssets').
%
% aioListTypes( ... 'aioPrefs', aioPrefs) specify an explicit
% preferences struct to use, instead of getpref('VirtualScenesAssets').
%
% [types, typeLocations] = aioListTypes(varargin)
%
% 2016 RenderToolbox team

parser = MipInputParser();
parser.addParameter('locations', {}, @iscellstr);
parser.addAllPreferences('aioPrefs', 'VirtualScenesAssets', []);
parser.parseMagically('caller');

if isempty(locations)
    locations = {aioPrefs.locations.name};
end


%% List types from each location.
nLocations = numel(locations);
locationResults = cell(1, nLocations);
locationNames = cell(1, nLocations);
for ll = 1:nLocations
    strategy = aioChooseStrategy(locations{ll}, 'aioPrefs', aioPrefs);
    if isempty(strategy)
        continue;
    end
    
    locationResults{ll} = strategy.list();
    locationNames{ll} = repmat(locations(ll), size(locationResults{ll}));
end

types = cat(2, locationResults{:});
typeLocations = cat(2, locationNames{:});

