classdef AioExamplesTests < matlab.unittest.TestCase
    % Test listing and getting some expected example assets.
    
    properties
        aioPrefs = struct('locations', aioLocation( ...
            'name', 'examples', ...
            'strategy', 'AioFileSystemStrategy', ...
            'baseDir', AioExamplesTests.exampleFolder()));
    end
    
    methods (Static)
        function folder = exampleFolder()
            if 2 ~= exist('vseaRoot', 'file')
                % deploy example assets repo on demand
                %   that way, only dev/test people need to get it
                record = tbToolboxRecord( ...
                    'name', 'VirtualScenesExampleAssets', ...
                    'type', 'git', ...
                    'url', 'https://github.com/RenderToolbox/VirtualScenesExampleAssets.git');
                tbDeployToolboxes('config', record);
            end
            folder = fullfile(vseaRoot(), 'examples');
        end
    end
    
    methods (Test)
        
        function testListTypes(testCase)
            types = aioListTypes( ...
                'locations', {'examples'}, ...
                'aioPrefs', testCase.aioPrefs);
            sortedTypes = sort(types);
            expectedTypes = { ...
                'BaseScenes', 'Illuminants', 'IndicesOfRefraction', ...
                'Objects', 'Reflectances', 'Textures'};
            testCase.assertEqual(sortedTypes, expectedTypes);
        end
        
        function testListExistingNames(testCase)
            names = aioListAssets('BaseScenes', ...
                'locations', {'examples'}, ...
                'aioPrefs', testCase.aioPrefs);
            sortedNames = sort(names);
            expectedNames = { ...
                'CheckerBoard', 'IndoorPlant', 'Library', ...
                'Mill', 'TableChairs', 'Warehouse'};
            testCase.assertEqual(sortedNames, expectedNames);
        end
        
        function testListBogusNames(testCase)
            names = aioListAssets('Bogus', ...
                'locations', {'examples'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEmpty(names);
        end
        
        function testGetExistingInfo(testCase)
            [info, location] = aioGetInfo('BaseScenes', 'CheckerBoard', ...
                'locations', {'examples'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEqual(location, 'examples');
            testCase.assertNotEmpty(info);
            testCase.assertInstanceOf(info, 'struct');
        end
        
        function testGetBogusInfo(testCase)
            [info, location] = aioGetInfo('Bogus', 'CheckerBoard', ...
                'locations', {'examples'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEmpty(info);
            testCase.assertEmpty(location);
            
            [info, location] = aioGetInfo('BaseScenes', 'Bogus', ...
                'locations', {'examples'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEmpty(info);
            testCase.assertEmpty(location);
        end
        
        function testGetExistingFiles(testCase)
            [files, location] = aioGetFiles('BaseScenes', 'CheckerBoard', ...
                'locations', {'examples'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEqual(location, 'examples');
            testCase.assertNotEmpty(files);
            testCase.assertInstanceOf(files, 'cell');
        end
        
        function testGetBogusFiles(testCase)
            [files, location] = aioGetFiles('Bogus', 'CheckerBoard', ...
                'locations', {'examples'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEmpty(files);
            testCase.assertEmpty(location);
            
            [files, location] = aioGetFiles('BaseScenes', 'Bogus', ...
                'locations', {'examples'}, ...
                'aioPrefs', testCase.aioPrefs);
            testCase.assertEmpty(files);
            testCase.assertEmpty(location);
        end
        
    end
end