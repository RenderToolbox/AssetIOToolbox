function [assetInfo, location] = aioGetInfo(assetType, assetName, varargin)
%% Get info about an existing asset.
%
% [assetInfo, location] = aioGetInfo(assetType, assetName) attempts to
% locate an asset with the given assetType and assetName.  If found,
% returns the asset info struct and the location where the asset was
% found.
%
% aioGetInfo( ... 'locations', locations) specify a cell array of
% locations where to try to get assets, in the given order.  The default
% is taken from getpref('VirtualScenesAssets').
%
% aioGetInfo( ... 'aioPrefs', aioPrefs) specify an explicit
% preferences struct to use, instead of getpref('VirtualScenesAssets').
%
% [assetInfo, location] = aioGetInfo(assetType, assetName, varargin)
%
% 2016 RenderToolbox team

parser = MipInputParser();
parser.addRequired('assetType', @ischar);
parser.addRequired('assetName', @ischar);
parser.addParameter('locations', {}, @iscellstr);
parser.addAllPreferences('aioPrefs', 'VirtualScenesAssets', []);
parser.parseMagically('caller');

if isempty(locations)
    locations = {aioPrefs.locations.name};
end


%% Is there any such asset?
[assetNames, assetLocations] = aioListAssets(assetType, ...
    'locations', locations, ...
    'aioPrefs', aioPrefs);
isMatch = strcmp(assetNames, assetName);
if ~any(isMatch)
    assetInfo = [];
    location = '';
    return;
end

%% Load it.
location = assetLocations{find(isMatch, 1, 'first')};
strategy = aioChooseStrategy(location, 'aioPrefs', aioPrefs);
assetInfo = strategy.getInfo(assetType, assetName);
