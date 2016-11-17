function [assetInfo, assetFiles] = vsaPut(assetType, assetName, varargin)
%% Put a new asset into the collection.
%
% [assetInfo, assetFiles] = vsaPut(assetType, assetName, varargin) creates
% a new asset in the "local" location, with the given assetType and
% assetName, and any additional struct or name-value pairs passed as
% varargin.
%
% Returns a struct representing the assetInfo and a cell array of saved
% asset file names, if any.
%
% vsaPut( ... 'files', files) specify a cell array of files to copy into
% the new asset folder.
%
% vsaPut( ... 'extras', extras) specify a cell array of extra, non-data
% files to store in the asset folder.
%
% vsaPut( ... 'location', location) specifies a specific location for the
% new asset.  Must be the name of one of the locations found in
% getpref('VirtualScenesAssets').
%
% vsaPut( ... 'vsaPrefs', vsaPrefs) specify an explicit
% preferences struct to use, instead of getpref('VirtualScenesAssets').
%
% vsaPut( ... 'ifConflict', ifConflict) specifies what to do in case an
% asset already exists with the same assetType and assetName, at the given
% location:
%   - 'skip', -- just skip if there's a conflict
%   - 'error' -- conflicts throw an error (default)
%   - 'merge' -- merge new and existing asset info and files
%   - 'replace' -- replace an existing asset with the new asset
%
% assetInfo = vsaPut(assetType, assetName, varargin)
%
% 2016 RenderToolbox team

parser = MipInputParser();
parser.addRequired('assetType', @ischar);
parser.addRequired('assetName', @ischar);
parser.addParameter('files', {}, @iscellstr);
parser.addParameter('extras', {}, @iscellstr);
parser.addParameter('location', '',@ischar);
parser.addParameter('ifConflict', 'error', MipInputParser.isAny('skip', 'error', 'merge', 'replace'));
parser.addAllPreferences('vsaPrefs', 'VirtualScenesAssets', []);
parser.parseMagically('caller');

if isempty(location)
    location = vsaPrefs.locations(1).name;
end

assetInfo = parser.Unmatched;

strategy = vsaChooseStrategy(location, 'vsaPrefs', vsaPrefs);
[assetInfo, assetFiles] = strategy.put(assetType, assetName, assetInfo, files, extras, ifConflict);
