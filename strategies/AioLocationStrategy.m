classdef AioLocationStrategy < handle
    % Abstract interface for working with assets at different locations.
    
    properties
        location = '';
    end
    
    methods (Abstract)
        % What assets are available at the location, by type and name?
        names = list(obj, varargin);
        
        % Get asset file list for given type and name from the location.
        assetFiles = getFiles(obj, assetType, assetName, varargin);
        
        % Get asset metadata for given type and name from the location.
        assetInfo = getInfo(obj, assetType, assetName)
        
        % Delete an asset with the given type and name from the location.
        delete(obj, assetType, assetName);
        
        % Add asset info and files to the location, merge if necessary.
        [assetInfo, assetFiles] = write(obj, assetType, assetName, assetInfo, assetFiles, extras);
    end
    
    methods
        % Add an asset to the location, deal with conflicts as needed.
        function [assetInfo, assetFiles] = put(obj, assetType, assetName, assetInfo, assetFiles, extras, ifConflict)
            if isempty(obj.list('assetType', assetType, 'assetName', assetName))
                obj.write(assetType, assetName, assetInfo, assetFiles, extras);
            else
                switch ifConflict
                    case 'skip'
                        assetInfo = obj.getInfo(assetType, assetName);
                        assetFiles = obj.getFiles(assetType, assetName);
                        
                    case 'error'
                        error('AioLocationStrategy:putConflict', ...
                            'Asset with type <%s> and name <%s> already exists at location <%s>.', ...
                            assetType, assetName, obj.location);
                        
                    case 'merge'
                        existingInfo = obj.getInfo(assetType, assetName);
                        existingFields = fieldnames(existingInfo);
                        for ff = 1:numel(existingFields)
                            field = existingFields{ff};
                            assetInfo.(field) = existingInfo.(field);
                        end
                        obj.write(assetType, assetName, assetInfo, assetFiles, extras);
                        
                    case 'replace'
                        obj.delete(assetType, assetName);
                        obj.write(assetType, assetName, assetInfo, assetFiles, extras);
                end
            end
        end
    end
end
