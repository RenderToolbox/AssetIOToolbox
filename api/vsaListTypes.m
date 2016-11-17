function [types, typeLocations] = vsaListTypes(varargin)
%% What types of asset are available?
%
% [types, typeLocations] = vsaListTypes() returns a cell array of asset
% types available at the default locations, and a cell arrays of locations,
% one for each type.
%
% vsaListTypes( ... 'locations', locations) specify a cell array of
% locations where to try to list asset types, in the given order.  The
% default is taken from getpref('VirtualScenesAssets').
%
% vsaListTypes( ... 'vsaPrefs', vsaPrefs) specify an explicit
% preferences struct to use, instead of getpref('VirtualScenesAssets').
%
% [types, typeLocations] = vsaListTypes(varargin)
%
% 2016 RenderToolbox team

parser = MipInputParser();
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
    
    locationResults{ll} = strategy.list();
    locationNames{ll} = repmat(locations(ll), size(locationResults{ll}));
end

types = cat(2, locationResults{:});
typeLocations = cat(2, locationNames{:});

