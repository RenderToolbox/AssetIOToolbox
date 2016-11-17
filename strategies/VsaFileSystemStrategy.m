classdef VsaFileSystemStrategy < VsaLocationStrategy
    % Work with assets on the local file system.
    
    properties
        baseDir = '';
    end
    
    methods
        function obj = VsaFileSystemStrategy(varargin)
            parser = MipInputParser();
            parser.addProperties(obj);
            parser.parseMagically(obj);
        end
        
        % Does the location have an asset with the given type and name?
        function results = list(obj, varargin)
            parser = MipInputParser();
            parser.addParameter('assetType', '', @ischar);
            parser.addParameter('assetName', '', @ischar);
            parser.parseMagically('caller');
            
            results = {};
            
            if isempty(assetType)
                % list the types
                assetPath = fullfile(obj.baseDir);
                if 7 == exist(assetPath, 'dir');
                    assetListing = dir(assetPath);
                    isReal = cellfun(@(name)isempty(strfind(name, '.')), {assetListing.name});
                    results = {assetListing(isReal).name};
                end
            else
                if isempty(assetName)
                    % list all names under the given type
                    assetPath = fullfile(obj.baseDir, assetType);
                    if 7 == exist(assetPath, 'dir');
                        assetListing = dir(assetPath);
                        isReal = cellfun(@(name)isempty(strfind(name, '.')), {assetListing.name});
                        results = {assetListing(isReal).name};
                    end
                else
                    % check for one name under the given type
                    assetPath = fullfile(obj.baseDir, assetType, assetName);
                    if 7 == exist(assetPath, 'dir');
                        results = {assetName};
                    end
                end
            end
            
        end
        
        % Get asset file list for given type and name from the location.
        function assetFiles = getFiles(obj, assetType, assetName, varargin)
            parser = MipInputParser();
            parser.addRequired('assetType', @ischar);
            parser.addRequired('assetName', @ischar);
            parser.addParameter('fullPaths', true, @islogical);
            parser.addParameter('nameFilter', '', @ischar);
            parser.parseMagically('caller');
            
            assetPath = fullfile(obj.baseDir, assetType, assetName);
            
            % resolve files other than the info file
            assetDir = dir(assetPath);
            assetDirNames = {assetDir(~[assetDir.isdir]).name};
            isInfoFile = strcmp(assetDirNames, 'info.mat');
            assetFiles = assetDirNames(~isInfoFile);
            
            if ~isempty(nameFilter)
                % select files by regular expression
                isMatch = cellfun( ...
                    @(name)~isempty(regexp(name, nameFilter, 'once')), ...
                    assetFiles, ...
                    'UniformOutput', true);
                assetFiles = assetFiles(isMatch);
            end

            if fullPaths
                % append folder path to each file name
                assetFiles = cellfun( ...
                    @(name)fullfile(assetPath, name), ...
                    assetFiles, ...
                    'UniformOutput', false);
            end
        end
        
        % Get asset metadata for given type and name from the location.
        function assetInfo = getInfo(obj, assetType, assetName)
            parser = MipInputParser();
            parser.addRequired('assetType', @ischar);
            parser.addRequired('assetName', @ischar);
            parser.parseMagically('caller');
            
            assetPath = fullfile(obj.baseDir, assetType, assetName);
            infoPath = fullfile(assetPath, 'info.mat');
            assetInfo = load(infoPath);
        end
        
        % Put an asset with info and files to the location.
        function [assetInfo, assetFiles] = write(obj, assetType, assetName, assetInfo, assetFiles, extras)
            assetFolder = fullfile(obj.baseDir, assetType, assetName);
            if 7 ~= exist(assetFolder, 'dir')
                mkdir(assetFolder);
            end
            
            % create or update info file
            infoPath = fullfile(assetFolder, 'info.mat');
            save(infoPath, '-struct', 'assetInfo');
            
            % create or update data files
            for ff = 1:numel(assetFiles)
                fileName = assetFiles{ff};
                [~, fileBase, fileExt] = fileparts(fileName);
                destination = fullfile(assetFolder, [fileBase fileExt]);
                copyfile(fileName, destination, 'f');
            end
            
            if ~isempty(extras)
                % create or update extra files
                extrasFolder = fullfile(assetFolder, 'extras');
                if 7 ~= exist(extrasFolder, 'dir')
                    mkdir(extrasFolder);
                end
                for ff = 1:numel(extras)
                    fileName = extras{ff};
                    [~, fileBase, fileExt] = fileparts(fileName);
                    destination = fullfile(extrasFolder, [fileBase fileExt]);
                    copyfile(fileName, destination, 'f');
                end
            end
        end
        
        % Delete an asset with the given type and name from the location.
        function delete(obj, assetType, assetName)
            assetPath = fullfile(obj.baseDir, assetType, assetName);
            if 7 == exist(assetPath, 'dir')
                rmdir(assetPath, 's');
            end
        end
        
    end
end
