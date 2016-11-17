function [assetFiles, location] = aioGetFiles(assetType, assetName, varargin)
%% Get info about an existing asset.
%
% [assetInfo, location] = aioGetFiles(assetType, assetName) attempts to
% locate an asset with the given assetType and assetName.  If found,
% returns a list of asset files and the location where the asset was
% found.
%
% aioGetFiles( ... 'fullPaths', fullPaths) specify whether to return full
% absoloute paths to asset files (true), or just the file names (false).
% The default is true, return full absolute paths.
%
% aioGetFiles( ... 'locations', locations) specify a cell array of
% locations where to try to get assets, in the given order.  The default
% is taken from getpref('VirtualScenesAssets').
%
% aioGetFiles( ... 'aioPrefs', aioPrefs) specify an explicit
% preferences struct to use, instead of getpref('VirtualScenesAssets').
%
% [assetFiles, location] = aioGetFiles(assetType, assetName, varargin)
%
% 2016 RenderToolbox team

parser = MipInputParser();
parser.addRequired('assetType', @ischar);
parser.addRequired('assetName', @ischar);
parser.addParameter('fullPaths', true, @islogical);
parser.addParameter('nameFilter', '', @ischar);
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
    assetFiles = {};
    location = '';
    return;
end

%% Load it.
location = assetLocations{find(isMatch, 1, 'first')};
strategy = aioChooseStrategy(location, 'aioPrefs', aioPrefs);
assetFiles = strategy.getFiles(assetType, assetName, ...
    'fullPaths', fullPaths, ...
    'nameFilter', nameFilter);
