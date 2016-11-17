%% Set up preferences for working with VirtualScenesAssets.
%
% You should copy this script and edit the preference values for your local
% machine.  You should run your copy of this script before working with
% VirtualScenesAssets.
%
% 2016 RenderToolbox team


%% Where to look for locally stored assets.  Change this for your machine.
userPath = userpath();
firstDelimiter = find(userPath == pathsep(), 1, 'first');
userFolder = userPath(1:firstDelimiter-1);
localFolder = fullfile(userFolder, 'LocalAssets');
local = vsaLocation( ...
    'name', 'local', ...
    'strategy', 'VsaFileSystemStrategy', ...
    'baseDir', localFolder);


%% Where to look for remotely stored assets.
% TODO: set up RemoteDataToolbox.
remote = vsaLocation('name', 'remote');


%% Where to look for example assets.
% the default is a separate toolbox called VirtualScenesExampleAssets
examples = vsaLocation( ...
    'name', 'examples', ...
    'strategy', 'VsaFileSystemStrategy', ...
    'baseDir', fullfile(vseaRoot(), 'examples'));


%% Pack up the locations as a Matlab preference.
setpref('VirtualScenesAssets', 'locations', [examples local remote]);
