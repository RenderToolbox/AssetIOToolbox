%% Set up preferences for working with AssetIOToolbox.
%
% You should copy this script and edit the preference values for your local
% machine.  You should run your copy of this script before working with
% AssetIOToolbox.
%
% 2016 RenderToolbox team


%% Where to look for locally stored assets.  Change this for your machine.
userPath = userpath();
firstDelimiter = find(userPath == pathsep(), 1, 'first');
userFolder = userPath(1:firstDelimiter-1);
localFolder = fullfile(userFolder, 'LocalAssets');
local = aioLocation( ...
    'name', 'local', ...
    'strategy', 'AioFileSystemStrategy', ...
    'baseDir', localFolder);


%% Where to look for remotely stored assets.
% TODO: set up RemoteDataToolbox.
remote = aioLocation('name', 'remote');


%% Where to look for example assets.
% the default is a separate toolbox called VirtualScenesExampleAssets
examples = aioLocation( ...
    'name', 'examples', ...
    'strategy', 'AioFileSystemStrategy', ...
    'baseDir', fullfile(vseaRoot(), 'examples'));


%% Pack up the locations as a Matlab preference.
setpref('AssetIOToolbox', 'locations', [examples local remote]);
