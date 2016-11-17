function rootPath = vsaRoot()
%% Get the path to VirtualScenesAssets.
%
% rootPath = vsaRoot() returns the absolute path to VirtualScenesAssets,
% based on the location of this file, vsaRoot.m.
%
% 2016 RenderToolbox team

fullPathHere = mfilename('fullpath');
rootPath = fileparts(fileparts(fullPathHere));

