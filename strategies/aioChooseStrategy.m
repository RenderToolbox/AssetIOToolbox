function strategy = vsaChooseStrategy(location, varargin)
%% Choose a strategy implementation based on the given location name.
%
% strategy = vsaChooseStrategy(location) chooses and instantiates a
% VsaLocationStrategy implementation based on the given location name,
% using default preferences found in getpref('VirtualScenesAssets').
%
% vsaChooseStrategy( ... 'vsaPrefs', vsaPrefs) specify an explicit
% preferences struct to use, instead of getpref('VirtualScenesAssets').
% vsaPrefs.locations must contain a struct array of locations, as returned
% from vsaLocation().
%
% strategy = vsaChooseStrategy(location, varargin)
%
% 2016 RenderToolbox team

parser = MipInputParser();
parser.addRequired('location', @ischar);
parser.addAllPreferences('vsaPrefs', 'VirtualScenesAssets', []);
parser.parseMagically('caller');


%% Choose an asset location by name.
names = {vsaPrefs.locations.name};
isMatch = strcmp(names, location);
if ~any(isMatch);
    error('vsaChooseStrategy:noSuchLocation', ...
        'No location named "%s" could be found.', location);
end
location = vsaPrefs.locations(isMatch);


%% Instantiate the strategy for the chosen location.
if isempty(location.strategy)
    strategy = [];
    return;
end
constructorFunction = str2func(location.strategy);
strategy = feval(constructorFunction, ...
    location.config, ...
    'location', location.name);

