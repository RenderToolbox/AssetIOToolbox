function rootPath = aioRoot()
%% Get the path to VirtualScenesAssets.
%
% rootPath = aioRoot() returns the absolute path to VirtualScenesAssets,
% based on the location of this file, aioRoot.m.
%
% 2016 RenderToolbox team

fullPathHere = mfilename('fullpath');
rootPath = fileparts(fileparts(fullPathHere));

