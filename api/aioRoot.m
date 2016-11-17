function rootPath = aioRoot()
%% Get the path to AssetIOToolbox.
%
% rootPath = aioRoot() returns the absolute path to AssetIOToolbox,
% based on the location of this file, aioRoot.m.
%
% 2016 RenderToolbox team

fullPathHere = mfilename('fullpath');
rootPath = fileparts(fileparts(fullPathHere));

