function strategy = aioChooseStrategy(location, varargin)
%% Choose a strategy implementation based on the given location name.
%
% strategy = aioChooseStrategy(location) chooses and instantiates a
% AioLocationStrategy implementation based on the given location name,
% using default preferences found in getpref('VirtualScenesAssets').
%
% aioChooseStrategy( ... 'aioPrefs', aioPrefs) specify an explicit
% preferences struct to use, instead of getpref('VirtualScenesAssets').
% aioPrefs.locations must contain a struct array of locations, as returned
% from aioLocation().
%
% strategy = aioChooseStrategy(location, varargin)
%
% 2016 RenderToolbox team

parser = MipInputParser();
parser.addRequired('location', @ischar);
parser.addAllPreferences('aioPrefs', 'VirtualScenesAssets', []);
parser.parseMagically('caller');


%% Choose an asset location by name.
names = {aioPrefs.locations.name};
isMatch = strcmp(names, location);
if ~any(isMatch);
    error('aioChooseStrategy:noSuchLocation', ...
        'No location named "%s" could be found.', location);
end
location = aioPrefs.locations(isMatch);


%% Instantiate the strategy for the chosen location.
if isempty(location.strategy)
    strategy = [];
    return;
end
constructorFunction = str2func(location.strategy);
strategy = feval(constructorFunction, ...
    location.config, ...
    'location', location.name);

