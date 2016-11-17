function [assetInfo, location] = vsaGetInfo(assetType, assetName, varargin)
%% Get info about an existing asset.
%
% [assetInfo, location] = vsaGetInfo(assetType, assetName) attempts to
% locate an asset with the given assetType and assetName.  If found,
% returns the asset info struct and the location where the asset was
% found.
%
% vsaGetInfo( ... 'locations', locations) specify a cell array of
% locations where to try to get assets, in the given order.  The default
% is taken from getpref('VirtualScenesAssets').
%
% vsaGetInfo( ... 'vsaPrefs', vsaPrefs) specify an explicit
% preferences struct to use, instead of getpref('VirtualScenesAssets').
%
% [assetInfo, location] = vsaGetInfo(assetType, assetName, varargin)
%
% 2016 RenderToolbox team

parser = MipInputParser();
parser.addRequired('assetType', @ischar);
parser.addRequired('assetName', @ischar);
parser.addParameter('locations', {}, @iscellstr);
parser.addAllPreferences('vsaPrefs', 'VirtualScenesAssets', []);
parser.parseMagically('caller');

if isempty(locations)
    locations = {vsaPrefs.locations.name};
end


%% Is there any such asset?
[assetNames, assetLocations] = vsaListAssets(assetType, ...
    'locations', locations, ...
    'vsaPrefs', vsaPrefs);
isMatch = strcmp(assetNames, assetName);
if ~any(isMatch)
    assetInfo = [];
    location = '';
    return;
end

%% Load it.
location = assetLocations{find(isMatch, 1, 'first')};
strategy = vsaChooseStrategy(location, 'vsaPrefs', vsaPrefs);
assetInfo = strategy.getInfo(assetType, assetName);
